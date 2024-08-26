part of 'login_phone_cubit.dart';

class LoginPhoneState extends Equatable {
  const LoginPhoneState({
    this.phone = const Phone.initial(),
    this.otpCode = const OTP.initial(),
    this.countryCode = const CountryCode.initial(),
    this.status = FormzSubmissionStatus.initial,
    this.verId,
    this.errorMessage,
  });
  final Phone phone;
  final OTP otpCode;
  final FormzSubmissionStatus status;
  final CountryCode countryCode;
  final String? verId;
  final String? errorMessage;

  @override
  List<Object> get props => [phone, otpCode, countryCode, status];

  LoginPhoneState copyWith({
    Phone? phone,
    OTP? otpCode,
    FormzSubmissionStatus? status,
    CountryCode? countryCode,
    String? verId,
    String? errorMessage,
  }) {
    return LoginPhoneState(
      phone: phone ?? this.phone,
      otpCode: otpCode ?? this.otpCode,
      status: status ?? this.status,
      countryCode: countryCode ?? this.countryCode,
      verId: verId ?? this.verId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
