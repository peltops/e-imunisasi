import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/features/authentication/data/models/country_code.dart';
import 'package:eimunisasi/features/authentication/data/models/email.dart';
import 'package:eimunisasi/features/authentication/data/models/password.dart';
import 'package:eimunisasi/features/authentication/data/models/phone.dart';
import 'package:eimunisasi/features/authentication/data/repositories/auth_repository.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:eimunisasi/features/authentication/logic/cubit/signup_cubit/signup_cubit.dart';

@GenerateMocks([AuthRepository])
@GenerateNiceMocks(
    [MockSpec<Users>(), MockSpec<UserCredential>(), MockSpec<User>()])
import 'signup_cubit_test.mocks.dart';

void main() {
  late AuthRepository authRepository;
  late Users user;
  late User userFirebase;
  late UserCredential userCredential;

  final phone = "85211011003";
  final phoneInvalid = "8123456789";
  final countryCode = "+62";
  final countryCodeInvalid = "62";
  final email = "contoh@contoh.com";
  final emailInvalid = "contoh.com";
  final password = "Test123!";
  final passwordInvalid = "test123";

  setUp(() {
    authRepository = MockAuthRepository();
    user = MockUsers();
    userFirebase = MockUser();
    userCredential = MockUserCredential();
  });
  group(
    "emailChanged",
    () {
      final email = "contoh@contoh.com";
      final emailInvalid = "contoh.com";
      final password = "Test123!";
      final passwordInvalid = "test123";
      blocTest<SignUpCubit, SignUpState>(
        "emailChanged email is valid and password is valid",
        build: () => SignUpCubit(authRepository),
        seed: () => SignUpState(password: Password.dirty(password)),
        act: (cubit) => cubit.emailChanged(email),
        expect: () => [
          SignUpState(
            email: Email.dirty(email),
            password: Password.dirty(password),
            status: FormzStatus.valid,
          )
        ],
      );
      blocTest<SignUpCubit, SignUpState>(
        "emailChanged email is invalid and password is valid",
        build: () => SignUpCubit(authRepository),
        seed: () => SignUpState(password: Password.dirty(password)),
        act: (cubit) => cubit.emailChanged(emailInvalid),
        expect: () => [
          SignUpState(
            email: Email.dirty(emailInvalid),
            password: Password.dirty(password),
            status: FormzStatus.invalid,
          )
        ],
      );

      blocTest<SignUpCubit, SignUpState>(
        "emailChanged email is valid and password is invalid",
        build: () => SignUpCubit(authRepository),
        seed: () => SignUpState(password: Password.dirty(passwordInvalid)),
        act: (cubit) => cubit.emailChanged(email),
        expect: () => [
          SignUpState(
            email: Email.dirty(email),
            password: Password.dirty(passwordInvalid),
            status: FormzStatus.invalid,
          )
        ],
      );
    },
  );
  group('passwordChanged', () {
    blocTest<SignUpCubit, SignUpState>(
      "passwordChanged password is valid",
      build: () => SignUpCubit(authRepository),
      seed: () => SignUpState(email: Email.dirty(email)),
      act: (cubit) => cubit.passwordChanged(password),
      expect: () => [
        SignUpState(
          email: Email.dirty(email),
          password: Password.dirty(password),
          status: FormzStatus.valid,
        )
      ],
    );
    blocTest<SignUpCubit, SignUpState>(
      "passwordChanged password is invalid",
      build: () => SignUpCubit(authRepository),
      seed: () => SignUpState(email: Email.dirty(email)),
      act: (cubit) => cubit.passwordChanged(passwordInvalid),
      expect: () => [
        SignUpState(
          email: Email.dirty(email),
          password: Password.dirty(passwordInvalid),
          status: FormzStatus.invalid,
        )
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      "passwordChanged email is invalid",
      build: () => SignUpCubit(authRepository),
      seed: () => SignUpState(email: Email.dirty(emailInvalid)),
      act: (cubit) => cubit.passwordChanged(password),
      expect: () => [
        SignUpState(
          email: Email.dirty(emailInvalid),
          password: Password.dirty(password),
          status: FormzStatus.invalid,
        )
      ],
    );
  });

  group('countryCodeChanged', () {
    test('phone valid', () {
      expect(Phone.dirty(phone).valid, true);
    });

    test('phone invalid', () {
      expect(Phone.dirty(phoneInvalid).valid, false);
    });

    test('countryCode valid', () {
      expect(CountryCode.dirty(countryCode).valid, true);
    });

    test('countryCode invalid', () {
      expect(CountryCode.dirty(countryCodeInvalid).valid, false);
    });

    blocTest<SignUpCubit, SignUpState>(
      "countryCodeChanged countryCode is valid",
      build: () => SignUpCubit(authRepository),
      seed: () => SignUpState(phone: Phone.dirty(phone)),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect: () => [
        SignUpState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCode),
          status: FormzStatus.valid,
        )
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      "countryCodeChanged countryCode is invalid",
      build: () => SignUpCubit(authRepository),
      seed: () => SignUpState(phone: Phone.dirty(phone)),
      act: (cubit) => cubit.countryCodeChanged(countryCodeInvalid),
      expect: () => [
        SignUpState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCodeInvalid),
          status: FormzStatus.invalid,
        )
      ],
    );
  });

  group('phoneChanged', () {
    blocTest<SignUpCubit, SignUpState>(
      "phoneChanged phone is valid",
      build: () => SignUpCubit(authRepository),
      seed: () => SignUpState(countryCode: CountryCode.dirty(countryCode)),
      act: (cubit) => cubit.phoneChanged(phone),
      expect: () => [
        SignUpState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.valid,
        )
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      "phoneChanged phone is invalid",
      build: () => SignUpCubit(authRepository),
      seed: () => SignUpState(countryCode: CountryCode.dirty(countryCode)),
      act: (cubit) => cubit.phoneChanged(phoneInvalid),
      expect: () => [
        SignUpState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phoneInvalid),
          status: FormzStatus.invalid,
        )
      ],
    );
  });

  group('showHidePassword', () {
    blocTest<SignUpCubit, SignUpState>(
      "showHidePassword",
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.showHidePassword(),
      expect: () => [SignUpState(isShowPassword: true)],
    );

    blocTest<SignUpCubit, SignUpState>(
      "showHidePassword twice",
      build: () => SignUpCubit(authRepository),
      act: (cubit) {
        cubit.showHidePassword();
        cubit.showHidePassword();
      },
      expect: () => [
        SignUpState(isShowPassword: true),
        SignUpState(isShowPassword: false)
      ],
    );
  });

  group('signUpFormSubmitted', () {
    blocTest<SignUpCubit, SignUpState>(
      "signUpFormSubmitted status is invalid",
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.signUpFormSubmitted(),
      expect: () => [],
    );

    blocTest<SignUpCubit, SignUpState>(
      "signUpFormSubmitted status is valid",
      build: () {
        when(userCredential.user).thenReturn(userFirebase);

        when(authRepository.signUpWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) => Future.value(userCredential));
        when(authRepository.insertUserToDatabase(user: user))
            .thenAnswer((_) => Future.value());
        return SignUpCubit(authRepository);
      },
      seed: () => SignUpState(
        email: Email.dirty(email),
        password: Password.dirty(password),
        countryCode: CountryCode.dirty(countryCode),
        phone: Phone.dirty(phone),
        status: FormzStatus.valid,
      ),
      act: (cubit) => cubit.signUpFormSubmitted(),
      verify: (_) {
        verify(authRepository.signUpWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
      },
      expect: () => [
        SignUpState(
          email: Email.dirty(email),
          password: Password.dirty(password),
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionInProgress,
        ),
        SignUpState(
          email: Email.dirty(email),
          password: Password.dirty(password),
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionSuccess,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      "signUpFormSubmitted status is valid and error",
      build: () {
        when(authRepository.signUpWithEmailAndPassword(
          email: email,
          password: password,
        )).thenThrow(Exception());
        return SignUpCubit(authRepository);
      },
      seed: () => SignUpState(
        email: Email.dirty(email),
        password: Password.dirty(password),
        countryCode: CountryCode.dirty(countryCode),
        phone: Phone.dirty(phone),
        status: FormzStatus.valid,
      ),
      act: (cubit) => cubit.signUpFormSubmitted(),
      verify: (_) {
        verify(authRepository.signUpWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
      },
      expect: () => [
        SignUpState(
          email: Email.dirty(email),
          password: Password.dirty(password),
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionInProgress,
        ),
        SignUpState(
          email: Email.dirty(email),
          password: Password.dirty(password),
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionFailure,
        ),
      ],
    );
  });

  test('phone is invalid and countryCode is valid', () {
    final phoneDirty = Phone.dirty(phoneInvalid);
    final countryCodeDirty = CountryCode.dirty(countryCodeInvalid);
    expect((phoneDirty.invalid && countryCodeDirty.invalid), true);
    expect(Phone.dirty(phoneInvalid).invalid, true);
    expect(CountryCode.dirty(countryCodeInvalid).invalid, true);
  });

  group('sendOTPCode', () {
    blocTest<SignUpCubit, SignUpState>(
      "sendOTPCode phone and countryCode is invalid",
      seed: () => SignUpState(
        countryCode: CountryCode.dirty(countryCodeInvalid),
        phone: Phone.dirty(phoneInvalid),
      ),
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.sendOTPCode(),
      expect: () => [],
    );

    blocTest<SignUpCubit, SignUpState>(
      "sendOTPCode phone invalid and countryCode is valid",
      seed: () => SignUpState(
        countryCode: CountryCode.dirty(countryCode),
        phone: Phone.dirty(phoneInvalid),
      ),
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.sendOTPCode(),
      expect: () => [],
    );

    blocTest<SignUpCubit, SignUpState>(
      "sendOTPCode phone valid and countryCode is invalid",
      seed: () => SignUpState(
        countryCode: CountryCode.dirty(countryCodeInvalid),
        phone: Phone.dirty(phone),
      ),
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.sendOTPCode(),
      expect: () => [],
    );

    blocTest<SignUpCubit, SignUpState>(
      "sendOTPCode phone is valid and countryCode is valid, and isPhoneNumberExist is true",
      seed: () => SignUpState(
        countryCode: CountryCode.dirty(countryCode),
        phone: Phone.dirty(phone),
      ),
      setUp: () {
        final phoneNumber = countryCode + phone;
        when(
          authRepository.isPhoneNumberExist(phoneNumber),
        ).thenAnswer((_) => Future.value(true));
      },
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.sendOTPCode(),
      expect: () => [
        SignUpState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionInProgress,
        ),
        SignUpState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionFailure,
          errorMessage: AppConstant.PHONE_NUMBER_EXIST_ERROR,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      "sendOTPCode phone is valid and countryCode is valid, and isPhoneNumberExist is false",
      seed: () => SignUpState(
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
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.sendOTPCode(),
      expect: () => [
        SignUpState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionInProgress,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      "sendOTPCode phone is valid and countryCode is valid, and isPhoneNumberExist is false, and isPhoneNumberExist, verifyPhoneNumber throw error",
      seed: () => SignUpState(
        countryCode: CountryCode.dirty(countryCode),
        phone: Phone.dirty(phone),
      ),
      build: () => SignUpCubit(authRepository),
      act: (cubit) => cubit.sendOTPCode(),
      expect: () => [
        SignUpState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionInProgress,
        ),
        SignUpState(
          countryCode: CountryCode.dirty(countryCode),
          phone: Phone.dirty(phone),
          status: FormzStatus.submissionFailure,
        ),
      ],
    );
  });
}
