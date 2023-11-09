import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/authentication/data/repositories/auth_repository.dart';
import 'package:eimunisasi/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:eimunisasi/features/splash/data/repositories/splash_repository.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'authentication_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository, SplashRepository])
void main() {
  late AuthRepository mockAuthRepository;
  late SplashRepository mockSplashRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockSplashRepository = MockSplashRepository();
  });

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc initial state and after 3 seconds is AppStarted event",
    build: () => AuthenticationBloc(
      mockAuthRepository,
      mockSplashRepository,
    ),
    wait: Duration(seconds: 3),
    expect: () => [Loading(), Unauthenticated()],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc app started",
    build: () => AuthenticationBloc(
      mockAuthRepository,
      mockSplashRepository,
    ),
    act: (bloc) => bloc.add(AppStarted()),
    expect: () => [Loading(), Unauthenticated()],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc app started and splash screen is not seen",
    build: () {
      when(mockAuthRepository.isSignedIn()).thenAnswer((_) async => false);
      when(mockSplashRepository.isSeen()).thenAnswer((_) async => false);
      return AuthenticationBloc(
        mockAuthRepository,
        mockSplashRepository,
      );
    },
    act: (bloc) => bloc.add(AppStarted()),
    expect: () => [Loading(), Unauthenticated(isSeenOnboarding: false)],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc app started and user is signed in",
    build: () {
      when(mockAuthRepository.isSignedIn()).thenAnswer((_) async => true);
      when(mockAuthRepository.getUser()).thenAnswer(
        (_) async => Users(
          uid: '1',
          email: 'email',
        ),
      );
      return AuthenticationBloc(
        mockAuthRepository,
        mockSplashRepository,
      );
    },
    act: (bloc) => bloc.add(AppStarted()),
    expect: () =>
        [Loading(), Authenticated(user: Users(uid: '1', email: 'email'))],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc LoggedIn",
    build: () {
      when(mockAuthRepository.getUser()).thenAnswer(
        (_) async => Users(
          uid: '1234',
          email: 'email@email.com',
        ),
      );
      return AuthenticationBloc(
        mockAuthRepository,
        mockSplashRepository,
      );
    },
    act: (bloc) => bloc.add(LoggedIn()),
    expect: () => [
      Loading(),
      Authenticated(user: Users(uid: '1234', email: 'email@email.com'))
    ],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc LoggedOut Success",
    build: () {
      when(mockAuthRepository.signOut()).thenAnswer((_) async => {});
      return AuthenticationBloc(
        mockAuthRepository,
        mockSplashRepository,
      );
    },
    act: (bloc) => bloc.add(LoggedOut()),
    expect: () => [Loading(), Unauthenticated()],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc LoggedOut Failed",
    build: () {
      when(mockAuthRepository.signOut()).thenAnswer(
        (_) async => throw Exception(),);
      when(mockAuthRepository.getUser()).thenAnswer(
        (_) async => Users(
          uid: '1234',
          email: 'email@email.com',
        ),
      );
      return AuthenticationBloc(
        mockAuthRepository,
        mockSplashRepository,
      );
    },
    act: (bloc) => bloc.add(LoggedOut()),
    expect: () => [
      Loading(),
      AuthenticationError(message: 'Gagal logout. Silahkan coba lagi!'),
      Loading(),
      Authenticated(user: Users(uid: '1234', email: 'email@email.com'))
    ],
  );
}
