import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eimunisasi/features/splash/data/repositories/splash_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

@Singleton()
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;
  final SplashRepository splashRepository;
  final SupabaseClient supabaseClient;

  StreamSubscription<AuthState>? _authSubscription;
  AuthenticationBloc(
    this.authRepository,
    this.splashRepository,
    this.supabaseClient,
  ) : super(Uninitialized()) {
    _authSubcription();
    _splash();
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  void _authSubcription() {
    _authSubscription = supabaseClient.auth.onAuthStateChange.listen((
      event,
    ) {
      final authEvent = event.event;
      if (authEvent == AuthChangeEvent.signedIn) {
        add(LoggedIn());
        return;
      }
    });
  }

  void _splash() async {
    Future.delayed(const Duration(seconds: 3), () {
      add(AppStarted());
    });
  }

  void _onAppStarted(
    AppStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    print('AppStarted');
    emit(Loading());
    try {
      final isSignedIn = await authRepository.isSignedIn();
      if (isSignedIn) {
        final data = await authRepository.getUser();
        if (data == null) {
          emit(AuthenticationError(message: 'User tidak ditemukan'));
          return;
        }
        emit(Authenticated(user: data));
      } else {
        final isSeenOnboarding = await splashRepository.isSeen();
        emit(Unauthenticated(isSeenOnboarding: isSeenOnboarding));
      }
    } catch (_) {
      emit(Unauthenticated(isSeenOnboarding: true));
    }
  }

  void _onLoggedIn(
    LoggedIn event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(Loading());
    final data = await authRepository.getUser();
    if (data == null) {
      emit(AuthenticationError(message: 'User tidak ditemukan'));
      return;
    }
    emit(Authenticated(user: data));
  }

  void _onLoggedOut(
    LoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(Loading());
    final isSeenOnboarding = await splashRepository.isSeen();
    await authRepository.signOut().then((_) {
      emit(Unauthenticated(isSeenOnboarding: isSeenOnboarding));
    }).catchError((error) {
      log(
        error.toString(),
        name: 'Error LoggedOut',
      );
      emit(
        const AuthenticationError(message: 'Gagal logout. Silahkan coba lagi!'),
      );
    });
  }
}
