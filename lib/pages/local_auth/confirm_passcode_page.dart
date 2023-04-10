import 'package:eimunisasi/pages/home/home.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/services/local_auth_service.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';

class ConfirmPasscodePage extends StatefulWidget {
  final String passcode;
  const ConfirmPasscodePage({Key? key, required this.passcode})
      : super(key: key);

  @override
  _ConfirmPasscodePageState createState() => _ConfirmPasscodePageState();
}

class _ConfirmPasscodePageState extends State<ConfirmPasscodePage> {
  final LocalAuthService _localAuth = LocalAuthService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passcodeController = TextEditingController();

  // state
  bool loading = false;

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
                  const Text("Konfirmasi PIN!"),
                  const SizedBox(height: 16),
                  TextField(
                    maxLength: 4,
                    key: const Key(
                        'confirmPasscodeForm_passcodeInput_textField'),
                    controller: _passcodeController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Masukkan kembali PIN',
                      helperText: 'Konfirmasi 4-digit PIN',
                      // ignore: unrelated_type_equality_checks
                      errorText: _passcodeController.value != widget.passcode
                          ? 'PIN Tidak Sama!'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ButtonCustom(
                      key: const Key('confirmPasscodeForm_next_raisedButton'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          dismissKeyboard(context);
                          if (_passcodeController.value.text ==
                              widget.passcode) {
                            _localAuth
                                .setPasscode(_passcodeController.value.text)
                                .then(
                                  (value) => Navigator.of(context)
                                      .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => HomePage()),
                                          (route) => false),
                                );
                          } else {
                            snackbarCustom('PIN Tidak Sama!').show(context);
                          }
                        }
                      },
                      child: const Text(
                        'Konfirmasi',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
