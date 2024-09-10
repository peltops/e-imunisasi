import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/email.dart';
import '../../../data/models/password.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';

part 'login_state.dart';

@Injectable()
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
    ));
  }

  void showHidePassword() {
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
  }

  Future<void> logInWithCredentials() async {
    if (state.email.isNotValid || state.password.isNotValid) {
      return emit(
        state.copyWith(
          errorMessage: 'Please fill in the form correctly',
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure, errorMessage: e.message));
    }
  }

  Future<void> logInWithSeribaseOauth() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final result = await _authRepository.logInWithSeribaseOauth();
      if (!result) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: 'Failed to login with Seribase Oauth',
          ),
        );
      }
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure, errorMessage: e.message));
    }
  }
}
