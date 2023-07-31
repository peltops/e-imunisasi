import 'package:bloc/bloc.dart';
import 'package:eimunisasi/utils/string_extension.dart';
import 'package:injectable/injectable.dart';
import '../../../../../models/user.dart';
import '../../../data/models/country_code.dart';
import '../../../data/models/otp.dart';
import '../../../data/models/phone.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';

part 'login_phone_state.dart';

@Injectable()
class LoginPhoneCubit extends Cubit<LoginPhoneState> {
  LoginPhoneCubit(this._authRepository) : super(const LoginPhoneState());

  final AuthRepository _authRepository;

  void phoneChanged(String value) {
    final phone = Phone.dirty(value);
    emit(state.copyWith(
      phone: phone,
      status: Formz.validate([phone, state.otpCode, state.countryCode]),
    ));
  }

  void otpCodeChanged(String value) {
    final otpCode = OTP.dirty(value);
    emit(state.copyWith(
      otpCode: otpCode,
      status: Formz.validate([state.phone, otpCode, state.countryCode]),
    ));
  }

  void countryCodeChanged(String value) {
    final countryCode = CountryCode.dirty(value);
    emit(state.copyWith(
      countryCode: countryCode,
      status: Formz.validate([state.phone, state.otpCode, countryCode]),
    ));
  }

  void verIdChanged(String value) {
    emit(state.copyWith(verId: value, status: FormzStatus.pure));
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
      if (!isPhoneNumberExist) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            errorMessage:
                'Nomor HP belum terdaftar, silahkan daftar terlebih dahulu',
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
          emit(state.copyWith(
              status: FormzStatus.submissionFailure, errorMessage: e.message));
        },
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _authRepository.signInWithCredential(
            verificationId: state.verId.orEmpty,
            otp: state.otpCode.value,
          );
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        },
      );
    } catch (_) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
      ));
    }
  }

  void logInWithOTP() async {
    if (state.otpCode.invalid || state.phone.invalid) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final isPhoneNumberExist = await _authRepository.isPhoneNumberExist(
        state.phone.value,
      );
      final phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: state.verId.orEmpty,
        smsCode: state.otpCode.value,
      );
      final userResult = await _authRepository.signInWithCredential(
        verificationId: state.verId.orEmpty,
        otp: state.otpCode.value,
      );

      if (!isPhoneNumberExist) {
        final _newUser = Users(
          uid: userResult.user?.uid,
          email: userResult.user?.email,
          nomorhpIbu: userResult.user?.phoneNumber,
          golDarahAyah: '-',
          golDarahIbu: '-',
          verified: userResult.user?.emailVerified,
        );
        await _authRepository.insertUserToDatabase(user: _newUser);
      }
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: e.message,
        ),
      );
    }
  }
}
