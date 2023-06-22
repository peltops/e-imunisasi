part of 'signup_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.phone = const Phone.pure(),
    this.countryCode = const CountryCode.pure(),
    this.otpCode = const OTP.pure(),
    this.verId,
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.isShowPassword = false,
  });

  final Email email;
  final Password password;
  final Phone phone;
  final CountryCode countryCode;
  final OTP otpCode;
  final String? verId;
  final FormzStatus status;
  final String? errorMessage;
  final bool isShowPassword;

  @override
  List<Object?> get props => [
        email,
        password,
        phone,
        countryCode,
        otpCode,
        verId,
        status,
        errorMessage,
        isShowPassword,
      ];

  SignUpState copyWith({
    Email? email,
    Password? password,
    Phone? phone,
    CountryCode? countryCode,
    OTP? otpCode,
    String? verId,
    FormzStatus? status,
    String? errorMessage,
    bool? isShowPassword,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      otpCode: otpCode ?? this.otpCode,
      verId: verId ?? this.verId,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isShowPassword: isShowPassword ?? this.isShowPassword,
    );
  }
}
