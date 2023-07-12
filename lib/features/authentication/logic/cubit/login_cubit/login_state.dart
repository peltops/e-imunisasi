part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isShowPassword = false,
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final bool isShowPassword;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props =>
      [email, password, isShowPassword, status, errorMessage ?? ''];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
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