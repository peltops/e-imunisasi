import 'package:formz/formz.dart';

enum OTPValidationError { invalid }

class OTP extends FormzInput<String, OTPValidationError> {
  const OTP.initial() : super.pure('');

  const OTP.dirty([String value = '']) : super.dirty(value);

  static final RegExp _otpRegExp = RegExp(r'^\d{6}$');

  @override
  OTPValidationError? validator(String? value) {
    return _otpRegExp.hasMatch(value ?? '') ? null : OTPValidationError.invalid;
  }
}
