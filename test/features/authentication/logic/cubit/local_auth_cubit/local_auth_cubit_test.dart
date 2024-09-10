import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/authentication/data/models/passcode.dart';
import 'package:formz/formz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:eimunisasi/features/authentication/logic/cubit/local_auth_cubit/local_auth_cubit.dart';

@GenerateMocks([SharedPreferences])
import 'local_auth_cubit_test.mocks.dart';

void main() {
  late SharedPreferences sharedPreferences;
  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  group('passcodeChanged', () {
    blocTest<LocalAuthCubit, LocalAuthState>(
      "passcodeChanged Valid with 4 digit",
      build: () => LocalAuthCubit(sharedPreferences),
      act: (cubit) => cubit.passcodeChanged('1234'),
      expect: () => [
        LocalAuthState(
          passcode: Passcode.dirty('1234'),
        ),
      ],
    );

    blocTest<LocalAuthCubit, LocalAuthState>(
      "passcodeChanged Invalid with 3 digit",
      build: () => LocalAuthCubit(sharedPreferences),
      act: (cubit) => cubit.passcodeChanged('123'),
      expect: () => [
        LocalAuthState(
          passcode: Passcode.dirty('123'),
        ),
      ],
    );
  });

  group("passcodeConfirmChanged", () {
    blocTest<LocalAuthCubit, LocalAuthState>(
      "passcodeConfirmChanged Valid with 4 digit",
      build: () => LocalAuthCubit(sharedPreferences),
      seed: () => LocalAuthState(passcode: Passcode.dirty('1234')),
      act: (cubit) {
        cubit.passcodeConfirmChanged('1234');
      },
      expect: () => [
        LocalAuthState(
          passcode: Passcode.dirty('1234'),
          confirmPasscode: Passcode.dirty('1234'),
        ),
      ],
    );
    blocTest<LocalAuthCubit, LocalAuthState>(
      "passcodeConfirmChanged Invalid with 3 digit and not match",
      build: () => LocalAuthCubit(sharedPreferences),
      seed: () => LocalAuthState(passcode: Passcode.dirty('1234')),
      act: (cubit) {
        cubit.passcodeConfirmChanged('123');
      },
      expect: () => [
        LocalAuthState(
          passcode: Passcode.dirty('1234'),
          confirmPasscode: Passcode.dirty('123'),
        ),
      ],
    );
  });

  group('getPasscode', () {
    blocTest<LocalAuthCubit, LocalAuthState>(
      'getPasscode success',
      build: () {
        when(sharedPreferences.getInt('passCode')).thenAnswer((_) => 1234);
        return LocalAuthCubit(sharedPreferences);
      },
      act: (cubit) => cubit.getPasscode(),
      expect: () => [
        LocalAuthState(
          statusGet: FormzSubmissionStatus.inProgress,
        ),
        LocalAuthState(
          savedPasscode: Passcode.dirty('1234'),
          statusGet: FormzSubmissionStatus.success,
        ),
      ],
    );
    blocTest<LocalAuthCubit, LocalAuthState>(
      'getPasscode failed',
      build: () {
        when(sharedPreferences.getInt('passCode'))
            .thenAnswer((_) => throw Exception('error'));
        return LocalAuthCubit(sharedPreferences);
      },
      act: (cubit) => cubit.getPasscode(),
      expect: () => [
        LocalAuthState(
          statusGet: FormzSubmissionStatus.inProgress,
        ),
        LocalAuthState(
          errorMessage: 'Gagal mendapatkan passcode',
          statusGet: FormzSubmissionStatus.failure,
        ),
      ],
    );
  });
  group('checkPasscode', () {
    blocTest<LocalAuthCubit, LocalAuthState>(
      'checkPasscode success',
      build: () {
        when(sharedPreferences.getInt('passCode')).thenAnswer((_) => 1234);
        return LocalAuthCubit(sharedPreferences);
      },
      act: (cubit) {
        cubit.checkPasscode('1234');
      },
      expect: () => [
        LocalAuthState(statusGet: FormzSubmissionStatus.inProgress),
        LocalAuthState(statusGet: FormzSubmissionStatus.success),
      ],
    );
    blocTest<LocalAuthCubit, LocalAuthState>(
      'checkPasscode failed with passcode empty',
      build: () {
        when(sharedPreferences.getInt('passCode')).thenAnswer((_) => 1234);
        return LocalAuthCubit(sharedPreferences);
      },
      act: (cubit) {
        cubit.checkPasscode('');
      },
      expect: () => [
        LocalAuthState(
          errorMessage: 'Silahkan isi PIN',
          statusGet: FormzSubmissionStatus.failure,
        ),
      ],
    );
    blocTest<LocalAuthCubit, LocalAuthState>(
      'checkPasscode failed with passcode not match',
      build: () {
        when(sharedPreferences.getInt('passCode')).thenAnswer((_) => 1234);
        return LocalAuthCubit(sharedPreferences);
      },
      act: (cubit) {
        cubit.checkPasscode('123');
      },
      expect: () => [
        LocalAuthState(
          statusGet: FormzSubmissionStatus.inProgress,
        ),
        LocalAuthState(
          errorMessage: "Password Salah",
          statusGet: FormzSubmissionStatus.failure,
        ),
      ],
    );
    blocTest<LocalAuthCubit, LocalAuthState>(
      'checkPasscode failed with get passcode failed',
      build: () {
        when(sharedPreferences.getInt('passCode'))
            .thenThrow(Exception('error'));
        return LocalAuthCubit(sharedPreferences);
      },
      act: (cubit) {
        cubit.checkPasscode('123');
      },
      expect: () => [
        LocalAuthState(
          statusGet: FormzSubmissionStatus.inProgress,
        ),
        LocalAuthState(
            errorMessage: 'Terjadi Kesalahan',
            statusGet: FormzSubmissionStatus.failure),
      ],
    );
  });

  group('confirmPasscode', () {
    blocTest<LocalAuthCubit, LocalAuthState>(
      'confirmPasscode success',
      build: () {
        when(sharedPreferences.setInt('passCode', 1234))
            .thenAnswer((_) async => true);
        return LocalAuthCubit(sharedPreferences);
      },
      seed: () => LocalAuthState(
        passcode: Passcode.dirty('1234'),
        confirmPasscode: Passcode.dirty('1234'),
      ),
      act: (cubit) async => cubit.confirmPasscode(),
      expect: () => [
        LocalAuthState(
          passcode: Passcode.dirty('1234'),
          confirmPasscode: Passcode.dirty('1234'),
          statusSet: FormzSubmissionStatus.inProgress,
        ),
        LocalAuthState(
          passcode: Passcode.dirty('1234'),
          confirmPasscode: Passcode.dirty('1234'),
          statusSet: FormzSubmissionStatus.success,
        ),
      ],
    );
    blocTest<LocalAuthCubit, LocalAuthState>(
      'confirmPasscode failed with passcode and confirm passcode not match',
      build: () {
        return LocalAuthCubit(sharedPreferences);
      },
      seed: () => LocalAuthState(
        passcode: Passcode.dirty('1234'),
        confirmPasscode: Passcode.dirty('123'),
      ),
      act: (cubit) async => cubit.confirmPasscode(),
      expect: () => [
        LocalAuthState(
          passcode: Passcode.dirty('1234'),
          confirmPasscode: Passcode.dirty('123'),
          statusSet: FormzSubmissionStatus.inProgress,
        ),
        LocalAuthState(
          passcode: Passcode.dirty('1234'),
          confirmPasscode: Passcode.dirty('123'),
          errorMessage: "Passcode Salah",
          statusSet: FormzSubmissionStatus.failure,
        ),
      ],
    );
    blocTest<LocalAuthCubit, LocalAuthState>(
      'confirmPasscode failed with setPasscode throw exception',
      build: () {
        when(sharedPreferences.setInt('passCode', 1234))
            .thenThrow(Exception('error'));
        return LocalAuthCubit(sharedPreferences);
      },
      seed: () => LocalAuthState(
        passcode: Passcode.dirty('1234'),
        confirmPasscode: Passcode.dirty('1234'),
      ),
      act: (cubit) async => cubit.confirmPasscode(),
      expect: () => [
        LocalAuthState(
          passcode: Passcode.dirty('1234'),
          confirmPasscode: Passcode.dirty('1234'),
          statusSet: FormzSubmissionStatus.inProgress,
        ),
        LocalAuthState(
          passcode: Passcode.dirty('1234'),
          confirmPasscode: Passcode.dirty('1234'),
          errorMessage: 'Gagal menyimpan passcode',
          statusSet: FormzSubmissionStatus.failure,
        ),
      ],
    );
  });

  group('destroyPasscode', () {
    blocTest<LocalAuthCubit, LocalAuthState>(
      'destroyPasscode success',
      build: () {
        when(sharedPreferences.remove('passCode'))
            .thenAnswer((_) async => true);
        return LocalAuthCubit(sharedPreferences);
      },
      act: (cubit) => cubit.destroyPasscode(),
      expect: () => [
        LocalAuthState(statusDelete: FormzSubmissionStatus.inProgress),
        LocalAuthState(statusDelete: FormzSubmissionStatus.success),
      ],
    );
    blocTest<LocalAuthCubit, LocalAuthState>(
      'destroyPasscode failed with exception',
      build: () {
        when(sharedPreferences.remove('passCode'))
            .thenThrow(Exception('error'));
        return LocalAuthCubit(sharedPreferences);
      },
      act: (cubit) => cubit.destroyPasscode(),
      expect: () => [
        LocalAuthState(statusDelete: FormzSubmissionStatus.inProgress),
        LocalAuthState(
          statusDelete: FormzSubmissionStatus.failure,
          errorMessage: 'Gagal menghapus passcode',
        ),
      ],
    );
  });
}
