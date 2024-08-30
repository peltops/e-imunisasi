import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/email.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'reset_password_state.dart';

@Injectable()
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._authRepository) : super(const ResetPasswordState());

  final AuthRepository _authRepository;
  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
    ));
  }

  Future<void> resetPasswordFormSubmitted() async {
    if (state.email.isNotValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authRepository.forgetEmailPassword(email: state.email.value);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
