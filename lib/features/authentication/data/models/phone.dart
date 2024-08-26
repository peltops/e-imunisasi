import 'package:formz/formz.dart';

/// Validation errors for the [phone] [FormzInput].
enum PhoneValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template phone}
/// Form input for an phone input.
/// {@endtemplate}
class Phone extends FormzInput<String, PhoneValidationError> {
  /// {@macro phone}
  const Phone.initial() : super.pure('');

  /// {@macro phone}
  const Phone.dirty([String value = '']) : super.dirty(value);

  static final RegExp _phoneRegExp = RegExp(r'^[1-9]{1,3}[0-9]{10,13}$');

  @override
  PhoneValidationError? validator(String? value) {
    return _phoneRegExp.hasMatch(value ?? '')
        ? null
        : PhoneValidationError.invalid;
  }
}
