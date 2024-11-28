import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/authentication/data/models/email.dart';
import 'package:eimunisasi/features/authentication/data/models/password.dart';
import 'package:eimunisasi/features/authentication/data/repositories/auth_repository.dart';
import 'package:formz/formz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:eimunisasi/features/authentication/logic/cubit/login_cubit/login_cubit.dart';

@GenerateMocks([AuthRepository])
import 'login_cubit_test.mocks.dart';

void main() {
  late AuthRepository authRepository;
  setUp(() {
    authRepository = MockAuthRepository();
  });
  group('emailChanged', () {
    blocTest<LoginCubit, LoginState>(
      'emailChanged and password invalid',
      build: () => LoginCubit(authRepository),
      act: (cubit) => cubit.emailChanged('example@example.com'),
      expect: () => [
        LoginState(
          email: Email.dirty('example@example.com'),
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
  group('logInWithSeribaseOauth', () {
    blocTest<LoginCubit, LoginState>(
      'should success when logInWithSeribaseOauth return true',
      build: () {
        when(
          authRepository.logInWithSeribaseOauth(),
        ).thenAnswer((_) async => Future.value(true));
        return LoginCubit(authRepository);
      },
      act: (cubit) => cubit.logInWithSeribaseOauth(),
      expect: () => [
        LoginState(
          status: FormzSubmissionStatus.inProgress,
        ),
        LoginState(
          status: FormzSubmissionStatus.success,
        ),
      ],
    );
    blocTest<LoginCubit, LoginState>(
      'should failed when logInWithSeribaseOauth return false',
      build: () {
        when(
          authRepository.logInWithSeribaseOauth(),
        ).thenAnswer((_) async => Future.value(false));
        return LoginCubit(authRepository);
      },
      act: (cubit) => cubit.logInWithSeribaseOauth(),
      expect: () => [
        LoginState(
          status: FormzSubmissionStatus.inProgress,
        ),
        LoginState(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Failed to login with Seribase Oauth',
        ),
      ],
    );
    blocTest<LoginCubit, LoginState>(
      'should failed when logInWithSeribaseOauth throw error',
      build: () {
        when(
          authRepository.logInWithSeribaseOauth(),
        ).thenThrow(Exception('error'));
        return LoginCubit(authRepository);
      },
      act: (cubit) => cubit.logInWithSeribaseOauth(),
      expect: () => [
        LoginState(
          status: FormzSubmissionStatus.inProgress,
        ),
        LoginState(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Failed to login with Seribase Oauth',
        ),
      ],
    );
  });
}
