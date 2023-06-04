import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../models/user.dart';
import '../../../data/models/email.dart';
import '../../../data/models/password.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'signup_state.dart';

@Injectable()
class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository) : super(const SignUpState());

  final AuthRepository _authRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.password,
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.email,
        password,
      ]),
    ));
  }

  void showHidePassword() {
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final userResult = await _authRepository.signUpWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      final _newUser = Users(
        uid: userResult.user!.uid,
        email: userResult.user!.email,
        golDarahAyah: '-',
        golDarahIbu: '-',
        verified: userResult.user!.emailVerified,
      );
      await _authRepository.insertUserToDatabase(
        user: _newUser,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
