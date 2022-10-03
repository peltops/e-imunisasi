import 'package:eimunisasi/pages/home/home.dart';
import 'package:eimunisasi/pages/local_auth/confirm_passcode_page.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/services/local_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class PasscodePage extends StatefulWidget {
  const PasscodePage({Key key}) : super(key: key);

  @override
  _PasscodePageState createState() => _PasscodePageState();
}

class _PasscodePageState extends State<PasscodePage> {
  final LocalAuthService _localAuth = LocalAuthService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passcodeController = TextEditingController();

  // state
  bool loading = false;

  // State
  bool isSavedPasscode = false;
  String passcode = '';
  @override
  void initState() {
    _localAuth.passcode.then((value) {
      if (value != '') {
        setState(() {
          isSavedPasscode = true;
          passcode = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isSavedPasscode
                        ? "Silahkan Masukkan PIN Anda!"
                        : "Silahkan Atur PIN Anda!",
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      TextFormField(
                        maxLength: 4,
                        key: const Key('passcodeForm_passcodeInput_textField'),
                        controller: _passcodeController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Masukan PIN'),
                          LengthRangeValidator(
                              min: 4, max: 4, errorText: 'PIN 4 digit'),
                          // pattern number 4 digit
                          PatternValidator(r'^[0-9]{4}$',
                              errorText: 'PIN harus berupa angka'),
                        ]),
                        decoration: InputDecoration(
                          labelText: 'PIN',
                          helperText: 'Masukkan 4-digit PIN',
                        ),
                      ),
                      const SizedBox(height: 16),
                      !isSavedPasscode
                          ? const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "*Ini berguna sebagai kunci keamanan tambahan.",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.red),
                              ))
                          : Container(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _NextButton(
                    onPressed: () {
                      if (isSavedPasscode) {
                        if (_formKey.currentState.validate()) {
                          if (_passcodeController.text == passcode) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (route) => false);
                          } else {
                            snackbarCustom('PIN Salah!').show(context);
                          }
                        }
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ConfirmPasscodePage(
                              passcode: _passcodeController.text,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final Function onPressed;
  const _NextButton({Key key, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('passcodeForm_next_raisedButton'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: const Text('Selanjutnya'),
      ),
    );
  }
}
