part of 'signup_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.initial(),
    this.password = const Password.initial(),
    this.phone = const Phone.initial(),
    this.countryCode = const CountryCode.initial(),
    this.otpCode = const OTP.initial(),
    this.verId,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.isShowPassword = false,
  });

  final Email email;
  final Password password;
  final Phone phone;
  final CountryCode countryCode;
  final OTP otpCode;
  final String? verId;
  final FormzSubmissionStatus status;
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
    FormzSubmissionStatus? status,
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
