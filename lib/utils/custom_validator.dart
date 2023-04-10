import 'package:form_field_validator/form_field_validator.dart';

class CPhoneValidator extends TextFieldValidator {
  // pass the error text to the super constructor
  CPhoneValidator({String errorText = 'Masukan No.handphone yang valid'})
      : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String? value) {
    // return true if the value is valid according the your condition

    String patttern = r'(^\+([0-9]{1,3})([0-9]{10,13}))';
    RegExp regExp = new RegExp(patttern);
    return regExp.hasMatch(value!);
  }
}
