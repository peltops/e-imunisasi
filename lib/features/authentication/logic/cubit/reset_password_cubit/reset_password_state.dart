part of 'reset_password_cubit.dart';

class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Email email;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [email, status];

  ResetPasswordState copyWith({
    Email? email,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
