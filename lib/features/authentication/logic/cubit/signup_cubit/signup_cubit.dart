import 'package:bloc/bloc.dart';
import 'package:eimunisasi/utils/string_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../../../models/user.dart';
import '../../../data/models/country_code.dart';
import '../../../data/models/email.dart';
import '../../../data/models/otp.dart';
import '../../../data/models/password.dart';
import '../../../data/models/phone.dart';
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

  void countryCodeChanged(String value) {
    final countryCode = CountryCode.dirty(value);
    emit(state.copyWith(
      countryCode: countryCode,
      status: Formz.validate([state.phone, countryCode]),
    ));
  }

  void phoneChanged(String value) {
    final phone = Phone.dirty(value);
    emit(state.copyWith(
      phone: phone,
      status: Formz.validate([phone, state.countryCode]),
    ));
  }

  void showHidePassword() {
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
  }

  void sendOTPCode() async {
    final phoneNumber =
        state.countryCode.value + state.phone.value.removeZeroAtFirst();
    if (!state.phone.valid) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final isPhoneNumberExist = await _authRepository.isPhoneNumberExist(
      phoneNumber,
    );
    if (isPhoneNumberExist) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'Nomor HP sudah terdaftar, silahkan login',
        ),
      );
      return;
    }
    try {
      await _authRepository.verifyPhoneNumber(
        phone: phoneNumber,
        codeSent: (String verId, int? token) {
          emit(state.copyWith(status: FormzStatus.pure, verId: verId));
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(
            state.copyWith(
              status: FormzStatus.submissionFailure,
              errorMessage: e.message,
            ),
          );
        },
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _authRepository.signInWithCredential(
            credential,
          );
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        },
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
