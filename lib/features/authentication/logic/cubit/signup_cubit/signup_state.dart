part of 'signup_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.isShowPassword = false,
  });

  final Email email;
  final Password password;
  final FormzStatus status;
  final String? errorMessage;
  final bool isShowPassword;

  @override
  List<Object?> get props =>
      [email, password, status, errorMessage, isShowPassword];

  SignUpState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
    bool? isShowPassword,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isShowPassword: isShowPassword ?? this.isShowPassword,
    );
  }
}
