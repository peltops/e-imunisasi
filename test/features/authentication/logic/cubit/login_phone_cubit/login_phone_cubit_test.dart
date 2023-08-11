import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/authentication/data/models/country_code.dart';
import 'package:eimunisasi/features/authentication/data/models/otp.dart';
import 'package:eimunisasi/features/authentication/data/models/phone.dart';
import 'package:eimunisasi/features/authentication/data/repositories/auth_repository.dart';
import 'package:eimunisasi/features/authentication/logic/cubit/login_phone_cubit/login_phone_cubit.dart';
import 'package:eimunisasi/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<Users>(),
  MockSpec<UserCredential>(),
  MockSpec<PhoneAuthCredential>(),
  MockSpec<PhoneAuthProvider>(),
  MockSpec<User>(),
  MockSpec<OTP>(),
  MockSpec<Phone>(),
  MockSpec<CountryCode>(),
  MockSpec<AuthRepository>(),
  MockSpec<FirebaseAuth>()
])
import 'login_phone_cubit_test.mocks.dart';

// INFO: Pay attention to Mock Objects because it is shared between unit tests

void main() {
  late AuthRepository authRepository;

  final phone = "85211011003";
  final phoneInvalid = "8123456789";
  final countryCode = "62";
  final countryCodeInvalid = "+6";
  final otp = "123456";
  final otpInvalid = "12345";

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group("phoneChanged", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'phoneChanged: phone invalid and countryCode invalid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phoneInvalid),
        countryCode: CountryCode.dirty(countryCodeInvalid),
      ),
      act: (cubit) => cubit.phoneChanged(phone),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCodeInvalid),
          status: FormzStatus.invalid,
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'phoneChanged: phone valid and countryCode invalid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phoneInvalid),
        countryCode: CountryCode.dirty(countryCodeInvalid),
      ),
      act: (cubit) => cubit.phoneChanged(phone),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCodeInvalid),
          status: FormzStatus.invalid,
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'phoneChanged: phone invalid and countryCode valid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phoneInvalid),
        countryCode: CountryCode.dirty(countryCode),
      ),
      act: (cubit) => cubit.phoneChanged(phone),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCode),
          status: FormzStatus.invalid,
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'phoneChanged: phone valid and countryCode valid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phoneInvalid),
        countryCode: CountryCode.dirty(countryCode),
      ),
      act: (cubit) => cubit.phoneChanged(phone),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCode),
          status: FormzStatus.invalid,
        )
      ],
    );
  });

  group("countryCodeChanged", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'countryCodeChanged: countryCode invalid and phone invalid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phoneInvalid),
        countryCode: CountryCode.dirty(countryCodeInvalid),
      ),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phoneInvalid),
          countryCode: CountryCode.dirty(countryCode),
          status: FormzStatus.invalid,
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'countryCodeChanged: countryCode valid and phone invalid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phoneInvalid),
        countryCode: CountryCode.dirty(countryCodeInvalid),
      ),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phoneInvalid),
          countryCode: CountryCode.dirty(countryCode),
          status: FormzStatus.invalid,
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'countryCodeChanged: countryCode invalid and phone valid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phone),
        countryCode: CountryCode.dirty(countryCodeInvalid),
      ),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCode),
          status: FormzStatus.invalid,
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'countryCodeChanged: countryCode valid and phone valid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phone),
        countryCode: CountryCode.dirty(countryCodeInvalid),
      ),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCode),
          status: FormzStatus.invalid,
        )
      ],
    );
  });

  group("otpCodeChanged", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'otpCodeChanged: otpCode invalid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(
        otpCode: OTP.dirty("123456"),
      ),
      act: (cubit) => cubit.otpCodeChanged("1234567"),
      expect: () => [
        LoginPhoneState(
          otpCode: OTP.dirty("1234567"),
          status: FormzStatus.invalid,
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'otpCodeChanged: otpCode invalid',
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.otpCodeChanged(otpInvalid),
      expect: () => [
        LoginPhoneState(
          otpCode: OTP.dirty(otpInvalid),
          status: FormzStatus.invalid,
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'otpCodeChanged: otpCode valid',
      build: () => LoginPhoneCubit(authRepository),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phone),
        countryCode: CountryCode.dirty(countryCode),
      ),
      act: (cubit) => cubit.otpCodeChanged(otp),
      expect: () => [
        LoginPhoneState(
          otpCode: OTP.dirty(otp),
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCode),
          status: FormzStatus.valid,
        )
      ],
    );
  });

  group("verIdChanged", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'verIdChanged: verId valid',
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.verIdChanged("123456"),
      expect: () => [
        LoginPhoneState(
          verId: "123456",
          status: FormzStatus.pure,
        )
      ],
    );
  });

  group('sendOTPCode', () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      "sendOTPCode phone and countryCode is invalid",
      seed: () => LoginPhoneState(
        countryCode: CountryCode.dirty(countryCodeInvalid),
        phone: Phone.dirty(phoneInvalid),
      ),
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.sendOTPCode(),
      expect: () => [],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      "sendOTPCode phone invalid and countryCode is valid",
      seed: () => LoginPhoneState(
        countryCode: CountryCode.dirty(countryCode),
        phone: Phone.dirty(phoneInvalid),
      ),
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.sendOTPCode(),
      expect: () => [],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      "sendOTPCode phone valid and countryCode is invalid",
      seed: () => LoginPhoneState(
        countryCode: CountryCode.dirty(countryCodeInvalid),
        phone: Phone.dirty(phone),
      ),
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.sendOTPCode(),
      expect: () => [],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      "sendOTPCode phone is valid and countryCode is valid, and isPhoneNumberExist is true",
      seed: () => LoginPhoneState(
        countryCode: CountryCode.dirty(countryCode),
        phone: Phone.dirty(phone),
      ),
      setUp: () {
        final phoneNumber = countryCode + phone;
        when(
          authRepository.isPhoneNumberExist(phoneNumber),
        ).thenAnswer((_) => Future.value(true));
      },
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.sendOTPCode(),
      expect: () => [
        LoginPhoneState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionInProgress,
        ),
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      "sendOTPCode phone is valid and countryCode is valid, and isPhoneNumberExist is false",
      seed: () => LoginPhoneState(
        countryCode: CountryCode.dirty(countryCode),
        phone: Phone.dirty(phone),
      ),
      setUp: () {
        final phoneNumber = countryCode + phone;
        final codeSent = (String verificationId, int? resendToken) {};
        final verificationFailed = (FirebaseAuthException e) {};
        final verificationCompleted = (PhoneAuthCredential credential) {};
        when(authRepository.isPhoneNumberExist(
          phoneNumber,
        )).thenAnswer((_) => Future.value(false));
        when(authRepository.verifyPhoneNumber(
          phone: phone,
          codeSent: codeSent,
          verificationFailed: verificationFailed,
          verificationCompleted: verificationCompleted,
        ));
      },
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.sendOTPCode(),
      expect: () => [
        LoginPhoneState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionInProgress,
        ),
        LoginPhoneState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionFailure,
          errorMessage:
              'Nomor HP belum terdaftar, silahkan daftar terlebih dahulu',
        ),
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      "sendOTPCode phone is valid and countryCode is valid, and isPhoneNumberExist is false, and isPhoneNumberExist, verifyPhoneNumber throw error",
      seed: () => LoginPhoneState(
        countryCode: CountryCode.dirty(countryCode),
        phone: Phone.dirty(phone),
      ),
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.sendOTPCode(),
      expect: () => [
        LoginPhoneState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionInProgress,
        ),
        LoginPhoneState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionFailure,
        ),
      ],
    );
  });
}
