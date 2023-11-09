import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/authentication/data/models/country_code.dart';
import 'package:eimunisasi/features/authentication/data/models/otp.dart';
import 'package:eimunisasi/features/authentication/data/models/phone.dart';
import 'package:eimunisasi/features/authentication/data/repositories/auth_repository.dart';
import 'package:eimunisasi/features/authentication/logic/cubit/login_phone_cubit/login_phone_cubit.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
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
import 'login_with_otp_test.mocks.dart';

void main() {
  late AuthRepository authRepository;
  late Users user;
  late UserCredential userCredential;

  final phone = "85211011003";
  final countryCode = "62";
  final otp = "123456";
  final verId = "random_ver_id";
  final phoneInvalid = "8123456789";
  final otpInvalid = "12345";

  setUp(() {
    authRepository = MockAuthRepository();
    userCredential = MockUserCredential();
    user = MockUsers();
  });

  group("logInWithOTP", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      "logInWithOTP phone invalid and otpCode is invalid",
      seed: () => LoginPhoneState(
        otpCode: OTP.dirty(otpInvalid),
        phone: Phone.dirty(phoneInvalid),
      ),
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.logInWithOTP(),
      expect: () => [],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      "logInWithOTP phone is invalid and otpCode is valid",
      seed: () => LoginPhoneState(
        otpCode: OTP.dirty(otp),
        phone: Phone.dirty(phoneInvalid),
      ),
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.logInWithOTP(),
      expect: () => [],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      "logInWithOTP phone valid and otpCode is invalid",
      seed: () => LoginPhoneState(
        otpCode: OTP.dirty(otpInvalid),
        phone: Phone.dirty(phone),
      ),
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.logInWithOTP(),
      expect: () => [],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      "logInWithOTP phone is valid and otpCode is valid, and signInWithCredential is success",
      seed: () => LoginPhoneState(
        countryCode: CountryCode.dirty(countryCode),
        phone: Phone.dirty(phone),
        otpCode: OTP.dirty(otp),
        verId: verId,
      ),
      setUp: () {
        when(authRepository.isPhoneNumberExist(phone))
            .thenAnswer((_) => Future.value(false));
        when(
          authRepository.signInWithCredential(verificationId: verId, otp: otp),
        ).thenAnswer((_) => Future.value(userCredential));

        when(authRepository.insertUserToDatabase(user: user)).thenAnswer(
          (_) => Future.value(),
        );
      },
      build: () => LoginPhoneCubit(authRepository),
      act: (cubit) => cubit.logInWithOTP(),
      expect: () => [
        LoginPhoneState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          otpCode: OTP.dirty(otp),
          verId: verId,
          status: FormzStatus.submissionInProgress,
        ),
        LoginPhoneState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          otpCode: OTP.dirty(otp),
          verId: verId,
          status: FormzStatus.submissionSuccess,
        ),
      ],
    );
  });
}
