import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eimunisasi/features/splash/data/repositories/splash_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../../models/user.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

@Singleton()
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;
  final SplashRepository _splashRepository;

  AuthenticationBloc({
    required AuthRepository authRepository,
    required SplashRepository splashRepository,
  })  : _authRepository = authRepository,
        _splashRepository = splashRepository,
        super(Uninitialized()) {
    Future.delayed(const Duration(seconds: 3), () {
      add(AppStarted());
    });
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  void _onAppStarted(
      AppStarted event, Emitter<AuthenticationState> emit) async {
    print('AppStarted');
    emit(Loading());
    try {
      final isSignedIn = await _authRepository.isSignedIn();
      if (isSignedIn) {
        final data = await _authRepository.getUser();
        emit(Authenticated(user: data));
      } else {
        final isSeenOnboarding = await _splashRepository.isSeen();
        emit(Unauthenticated(isSeenOnboarding: isSeenOnboarding));
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(Loading());
    final data = await _authRepository.getUser();
    emit(Authenticated(user: data));
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(Loading());
    await _authRepository.signOut().then((value) {
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
