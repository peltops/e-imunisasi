import 'dart:async';

import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/auth.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

import '../wrapper.dart';

class OTPPage extends StatefulWidget {
  final phoneNumber;
  final verId;
  final description;
  const OTPPage({
    Key key,
    @required this.phoneNumber,
    @required this.verId,
    @required this.description,
  }) : super(key: key);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final AuthService _auth = AuthService();
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  bool newCode = false;
  bool loading = false;
  String error = '';
  Timer timer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        setState(() {
          newCode = true;
        });
        timer.cancel();
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException exception) {
      // throw exception;
      setState(() {
        error = 'Terjadi kesalahan, Silahkan coba beberapa saat lagi!';
        loading = false;
      });
    };
    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) {
      setState(() {
        loading = false;
      });
      snackbarCustom('Kode sudah dikirim ulang!');
    };
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: KeyboardAvoider(
        child: Container(
          color: Colors.pink[100],
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 35, horizontal: 15),
            child: Center(
                child: Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: KeyboardAvoider(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Masukan Kode OTP 6 Digit",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        SizedBox(
                          height: 15.0,
                        ),
                        error.isNotEmpty
                            ? Text(
                                error,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 15.0),
                              )
                            : Container(),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.phoneNumber,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextFormCustom(
                                keyboardType: TextInputType.phone,
                                hintText: '000000',
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: 'Masukan Kode OTP 6 Digit'),
                                  MinLengthValidator(6,
                                      errorText: 'Masukan Kode OTP 6 Digit'),
                                  MaxLengthValidator(6,
                                      errorText: 'Masukan Kode OTP 6 Digit'),
                                ]),
                                controller: _codeController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        buttonCustom(
                          textChild: !loading
                              ? Text(
                                  "Masuk",
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.white),
                                )
                              : SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                          onPressed: () {
                            dismissKeyboard(context);
                            final code = _codeController.text.trim();
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              if (widget.description == 'register') {
                                _auth
                                    .signUpWithOTP(
                                        code, widget.verId, widget.phoneNumber)
                                    .then((_) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => Wrapper()),
                                      (route) => false);
                                }).catchError((e) {
                                  snackbarCustom(e.message).show(context);
                                }).whenComplete(
                                        () => setState(() => loading = false));
                              } else if (widget.description == 'login') {
                                _auth
                                    .signInWithOTP(
                                        code, widget.verId, widget.phoneNumber)
                                    .then((_) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => Wrapper()),
                                      (route) => false);
                                }).catchError((e) {
                                  snackbarCustom(e.message).show(context);
                                }).whenComplete(
                                        () => setState(() => loading = false));
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Belum Menerima Kode?"),
                        SizedBox(
                          height: 10,
                        ),
                        !newCode && seconds > 0
                            ? Row(
                                children: [
                                  SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Tunggu $seconds ..."),
                                ],
                              )
                            : InkWell(
                                child: Text("Minta kode baru!",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onTap: () {
                                  setState(() {
                                    seconds = maxSeconds;
                                    newCode = false;
                                  });
                                  startTimer();
                                  try {
                                    _auth.verifyPhoneNumber(
                                      widget.phoneNumber,
                                      context,
                                      codeSent,
                                      verificationfailed,
                                    );
                                  } catch (e) {
                                    setState(() {
                                      loading = false;
                                    });
                                    snackbarCustom(
                                        'Terjadi masalah: ${e.toString()}');
                                  }
                                },
                              )
                      ]),
                ),
              )),
            )),
          ),
        ),
      ),
    );
  }
}
