import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eimunisasi/features/splash/data/repositories/splash_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

@Singleton()
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;
  final SplashRepository splashRepository;

  AuthenticationBloc(this.authRepository, this.splashRepository)
      : super(Uninitialized()) {
    _splash();
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  void _splash() async {
    Future.delayed(const Duration(seconds: 3), () {
      add(AppStarted());
    });
  }

  void _onAppStarted(
      AppStarted event, Emitter<AuthenticationState> emit) async {
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
      emit(Unauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(Loading());
    final data = await authRepository.getUser();
    if (data == null) {
      emit(AuthenticationError(message: 'User tidak ditemukan'));
      return;
    }
    emit(Authenticated(user: data));
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(Loading());
    await authRepository.signOut().then((_) {
      emit(Unauthenticated());
    }).catchError((error) {
      log(
        error.toString(),
        name: 'Error LoggedOut',
      );
      emit(
        const AuthenticationError(message: 'Gagal logout. Silahkan coba lagi!'),
      );
      add(LoggedIn());
    });
  }
}
