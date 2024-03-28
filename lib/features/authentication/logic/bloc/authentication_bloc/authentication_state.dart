part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Loading extends AuthenticationState {
  @override
  String toString() => 'Loading';
}

class Authenticated extends AuthenticationState {
  final Users user;
  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];

  @override
  String toString() => 'Authenticated { user: $user }';
}

class Unauthenticated extends AuthenticationState {
  final bool isSeenOnboarding;

  const Unauthenticated({this.isSeenOnboarding = false}) : super();

  @override
  List<Object?> get props => [isSeenOnboarding];

  @override
  String toString() => 'Unauthenticated';
}

class AuthenticationError extends AuthenticationState {
  final String message;

  const AuthenticationError({required this.message});

  @override
  String toString() => 'AuthenticationError { $message }';
}

class ResetPasswordSent extends AuthenticationState {
  @override
  String toString() => 'ResetPasswordSent';
}
