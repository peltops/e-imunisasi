part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.initial(),
    this.password = const Password.initial(),
    this.isShowPassword = false,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final bool isShowPassword;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  @override
  List<Object> get props =>
      [email, password, isShowPassword, status, errorMessage ?? ''];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    String? errorMessage,
    bool? isShowPassword,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isShowPassword: isShowPassword ?? this.isShowPassword,
    );
  }
}
