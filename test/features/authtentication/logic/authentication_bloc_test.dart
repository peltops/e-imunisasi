import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/authentication/data/repositories/auth_repository.dart';
import 'package:eimunisasi/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:eimunisasi/features/splash/data/repositories/splash_repository.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'authentication_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository, SplashRepository, SupabaseClient, GoTrueClient])
@GenerateNiceMocks([
  MockSpec<Session>(as: #MockSession),
  MockSpec<UserResponse>(as: #MockUserResponse),
])
void main() {
  late AuthRepository mockAuthRepository;
  late SplashRepository mockSplashRepository;
  late SupabaseClient mockSupabaseClient;
  late GoTrueClient mockGoTrueClient;
  late MockSession mockSession;
  late MockUserResponse mockUser;

  setUpAll(() {
    mockAuthRepository = MockAuthRepository();
    mockSplashRepository = MockSplashRepository();
    mockSupabaseClient = MockSupabaseClient();
    mockGoTrueClient = MockGoTrueClient();
    mockSession = MockSession();
    mockUser = MockUserResponse();

    when(mockGoTrueClient.getUser()).thenAnswer((_) async => mockUser);
    when(mockGoTrueClient.onAuthStateChange).thenAnswer(
      (_) => Stream.fromIterable([
        AuthState(
          AuthChangeEvent.initialSession,
          mockSession,
        ),
      ]),
    );
    when(mockSupabaseClient.auth).thenReturn(mockGoTrueClient);
  });

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc initial state and after 3 seconds is AppStarted event",
    build: () {
      when(mockAuthRepository.isSignedIn()).thenAnswer((_) async => false);
      when(mockSplashRepository.isSeen()).thenAnswer((_) async => true);
      when(mockAuthRepository.getUser()).thenAnswer((_) async => null);
      return AuthenticationBloc(
        mockAuthRepository,
        mockSplashRepository,
        mockSupabaseClient,
      );
    },
    wait: Duration(seconds: 3),
    expect: () => [
      Loading(),
      Unauthenticated(
        isSeenOnboarding: true,
      ),
    ],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc app started",
    build: () {
      when(mockAuthRepository.isSignedIn()).thenAnswer((_) async => false);
      when(mockSplashRepository.isSeen()).thenAnswer((_) async => true);
      return AuthenticationBloc(
        mockAuthRepository,
        mockSplashRepository,
        mockSupabaseClient,
      );
    },
    act: (bloc) => bloc.add(AppStarted()),
    expect: () => [Loading(), Unauthenticated(isSeenOnboarding: true)],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc app started and splash screen is not seen",
    build: () {
      when(mockAuthRepository.isSignedIn()).thenAnswer((_) async => false);
      when(mockSplashRepository.isSeen()).thenAnswer((_) async => false);
      return AuthenticationBloc(
        mockAuthRepository,
        mockSplashRepository,
        mockSupabaseClient,
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
        mockSupabaseClient,
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
        mockSupabaseClient,
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
        mockSupabaseClient,
      );
    },
    act: (bloc) => bloc.add(LoggedOut()),
    expect: () => [Loading(), Unauthenticated()],
  );

  blocTest<AuthenticationBloc, AuthenticationState>(
    "AuthenticationBloc LoggedOut Failed",
    build: () {
      when(mockSplashRepository.isSeen()).thenAnswer((_) async => true);
      when(mockAuthRepository.signOut()).thenAnswer(
        (_) async => throw Exception(),
      );
      when(mockAuthRepository.getUser()).thenAnswer(
        (_) async => Users(
          uid: '1234',
          email: 'email@email.com',
        ),
      );
      return AuthenticationBloc(
        mockAuthRepository,
        mockSplashRepository,
        mockSupabaseClient,
      );
    },
    act: (bloc) => bloc.add(LoggedOut()),
    expect: () => [
      Loading(),
      AuthenticationError(message: 'Gagal logout. Silahkan coba lagi!'),
    ],
  );
}
