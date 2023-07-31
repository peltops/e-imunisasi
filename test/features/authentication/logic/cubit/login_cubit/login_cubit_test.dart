import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/authentication/data/models/email.dart';
import 'package:eimunisasi/features/authentication/data/models/password.dart';
import 'package:eimunisasi/features/authentication/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:eimunisasi/features/authentication/logic/cubit/login_cubit/login_cubit.dart';

@GenerateMocks([AuthRepository, UserCredential])
import 'login_cubit_test.mocks.dart';

void main() {
  late AuthRepository authRepository;
  late UserCredential userCredential;
  setUp(() {
    authRepository = MockAuthRepository();
    userCredential = MockUserCredential();
  });
  group('emailChanged', () {
    blocTest<LoginCubit, LoginState>(
      'emailChanged and password invalid',
      build: () => LoginCubit(authRepository),
      act: (cubit) => cubit.emailChanged('example@example.com'),
      expect: () => [
        LoginState(
          email: Email.dirty('example@example.com'),
          status: FormzStatus.invalid,
        )
      ],
    );
    blocTest<LoginCubit, LoginState>(
      'emailChanged and password valid',
      build: () => LoginCubit(authRepository),
      seed: () => LoginState(password: Password.dirty('Admin123')),
      act: (cubit) => cubit.emailChanged('example@example.com'),
      expect: () => [
        LoginState(
          email: Email.dirty('example@example.com'),
          password: Password.dirty('Admin123'),
          status: FormzStatus.valid,
        )
      ],
    );
  });
  group('passwordChanged', () {
    blocTest<LoginCubit, LoginState>(
      'passwordChanged and email invalid',
      build: () => LoginCubit(authRepository),
      act: (cubit) => cubit.passwordChanged('Admin123'),
      expect: () => [
        LoginState(
          password: Password.dirty('Admin123'),
          status: FormzStatus.invalid,
        )
      ],
    );
    blocTest<LoginCubit, LoginState>(
      'passwordChanged and email valid',
      build: () => LoginCubit(authRepository),
      seed: () => LoginState(email: Email.dirty('example@example.com')),
      act: (cubit) => cubit.passwordChanged('Admin123'),
      expect: () => [
        LoginState(
          email: Email.dirty('example@example.com'),
          password: Password.dirty('Admin123'),
          status: FormzStatus.valid,
        )
      ],
    );
  });
  group('showHidePassword', () {
    blocTest<LoginCubit, LoginState>(
      'showHidePassword default value is false',
      build: () => LoginCubit(authRepository),
      act: (cubit) => cubit.showHidePassword(),
      expect: () => [
        LoginState(
          isShowPassword: true,
        )
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'showHidePassword default value is true',
      build: () => LoginCubit(authRepository),
      seed: () => LoginState(isShowPassword: true),
      act: (cubit) => cubit.showHidePassword(),
      expect: () => [LoginState(isShowPassword: false)],
    );
  });
  group('logInWithCredentials', () {
    blocTest<LoginCubit, LoginState>(
      'logInWithCredentials invalid',
      build: () => LoginCubit(authRepository),
      seed: () => LoginState(status: FormzStatus.invalid),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [],
    );
    blocTest<LoginCubit, LoginState>(
      'logInWithCredentials valid',
      build: () {
        when(
          authRepository.logInWithEmailAndPassword(
            email: 'example@example.com',
            password: 'Admin123',
          ),
        ).thenAnswer((_) async => Future.value(userCredential));
        return LoginCubit(authRepository);
      },
      seed: () => LoginState(
        email: Email.dirty('example@example.com'),
        password: Password.dirty('Admin123'),
        status: FormzStatus.valid,
      ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [
        LoginState(
          email: Email.dirty('example@example.com'),
          password: Password.dirty('Admin123'),
          status: FormzStatus.submissionInProgress,
        ),
        LoginState(
          email: Email.dirty('example@example.com'),
          password: Password.dirty('Admin123'),
          status: FormzStatus.submissionSuccess,
        ),
      ],
    );
    blocTest<LoginCubit, LoginState>(
      'logInWithCredentials valid but error',
      build: () {
        when(
          authRepository.logInWithEmailAndPassword(
            email: 'example@example.com',
            password: 'Admin123',
          ),
        ).thenThrow(FirebaseAuthException(code: 'code', message: 'error'));
        return LoginCubit(authRepository);
      },
      seed: () => LoginState(
        email: Email.dirty('example@example.com'),
        password: Password.dirty('Admin123'),
        status: FormzStatus.valid,
      ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [
        LoginState(
          email: Email.dirty('example@example.com'),
          password: Password.dirty('Admin123'),
          status: FormzStatus.submissionInProgress,
        ),
        LoginState(
          email: Email.dirty('example@example.com'),
          password: Password.dirty('Admin123'),
          status: FormzStatus.submissionFailure,
          errorMessage: 'error',
        ),
      ],
    );
  });
}
