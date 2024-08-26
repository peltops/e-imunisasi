import 'package:bloc/bloc.dart';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/utils/string_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/user.dart';
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
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
    ));
  }

  void countryCodeChanged(String value) {
    final countryCode = CountryCode.dirty(value);
    emit(state.copyWith(
      countryCode: countryCode,
    ));
  }

  void phoneChanged(String value) {
    final phone = Phone.dirty(value);
    emit(state.copyWith(
      phone: phone,
    ));
  }

  void showHidePassword() {
    emit(state.copyWith(isShowPassword: !state.isShowPassword));
  }

  Future<void> signUpFormSubmitted() async {
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
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  void sendOTPCode() async {
    final phoneNumber =
        state.countryCode.value + state.phone.value.removeZeroAtFirst();
    if (state.phone.isNotValid || state.countryCode.isNotValid) return;

    try {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final isPhoneNumberExist = await _authRepository.isPhoneNumberExist(
        phoneNumber,
      );
      if (isPhoneNumberExist) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: AppConstant.PHONE_NUMBER_EXIST_ERROR,
          ),
        );
        return;
      }
      await _authRepository.verifyPhoneNumber(
        phone: phoneNumber,
        codeSent: (String verId, int? token) {
          emit(
              state.copyWith(status: FormzSubmissionStatus.initial, verId: verId));
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: e.message,
            ),
          );
        },
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _authRepository.signInWithCredential(
            verificationId: credential.verificationId.orEmpty,
            otp: credential.smsCode.orEmpty,
          );
          emit(state.copyWith(status: FormzSubmissionStatus.success));
        },
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
