part of 'login_phone_cubit.dart';

class LoginPhoneState extends Equatable {
  const LoginPhoneState({
    this.phone = const Phone.pure(),
    this.otpCode = const OTP.pure(),
    this.countryCode = const CountryCode.pure(),
    this.status = FormzStatus.pure,
    this.verId,
    this.errorMessage,
  });
  final Phone phone;
  final OTP otpCode;
  final FormzStatus status;
  final CountryCode countryCode;
  final String? verId;
  final String? errorMessage;

  @override
  List<Object> get props => [phone, otpCode, countryCode, status];

  LoginPhoneState copyWith({
    Phone? phone,
    OTP? otpCode,
    FormzStatus? status,
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
