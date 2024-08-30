import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum PasscodeValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template password}
/// Form input for an password input.
/// {@endtemplate}
class Passcode extends FormzInput<String, PasscodeValidationError> {
  /// {@macro password}
  const Passcode.initial() : super.pure('');

  /// {@macro password}
  const Passcode.dirty([String value = '']) : super.dirty(value);

  static final _passcodeRegExp = RegExp(r'^\d{4}$');

  @override
  PasscodeValidationError? validator(String? value) {
    return _passcodeRegExp.hasMatch(value ?? '')
        ? null
        : PasscodeValidationError.invalid;
  }
}
