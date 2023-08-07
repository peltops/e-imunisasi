import 'package:bloc/bloc.dart';
import 'package:eimunisasi/core/utils/constant.dart';
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

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final userResult = await _authRepository.signUpWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      final _newUser = Users(
        uid: userResult.user?.uid,
        email: userResult.user?.email,
        nomorhpIbu: userResult.user?.phoneNumber,
        golDarahAyah: '-',
        golDarahIbu: '-',
        verified: userResult.user?.emailVerified,
      );
      await _authRepository.insertUserToDatabase(user: _newUser);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void sendOTPCode() async {
    final phoneNumber =
        state.countryCode.value + state.phone.value.removeZeroAtFirst();
    if (state.phone.invalid || state.countryCode.invalid) return;

    try {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      final isPhoneNumberExist = await _authRepository.isPhoneNumberExist(
        phoneNumber,
      );
      if (isPhoneNumberExist) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            errorMessage: AppConstant.PHONE_NUMBER_EXIST_ERROR,
          ),
        );
        return;
      }
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
            verificationId: credential.verificationId.orEmpty,
            otp: credential.smsCode.orEmpty,
          );
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        },
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
