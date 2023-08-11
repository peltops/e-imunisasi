import 'package:country_code_picker/country_code_picker.dart';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/auth.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //Email and Pass state
  bool loading = false;
  String? phoneNumber, verId, countryCode, momName, smsCode, email, error;
  bool codeOTPSent = false;
  @override
  void dispose() {
    super.dispose();
  }

  // siminfo
  String? _isoCountryCode;

  @override
  void initState() {
    super.initState();
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
      snackbarCustom('Terjadi masalah: ${exception.message.toString()}');
    };
    final PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) {
      setState(() {
        verId = verificationId;
        codeOTPSent = true;
        loading = false;
        loading = false;
      });
      var phone = phoneNumber!;

      if (phone[0] == '0') {
        phone = phone.substring(1);
      }
      phone = countryCode! + phone;
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //         builder: (context) => OTPPage(
      //               phoneNumber: phone,
      //               verId: verificationId,
      //               description: 'register',
      //             )),
      //     (route) => false);
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
      body: Container(
        color: Colors.pink[100],
        child: Card(
            margin: EdgeInsets.symmetric(vertical: 35, horizontal: 15),
            child: Center(
              child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        Text(AppConstant.SIGN_UP_ACTION,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppConstant.ALREADY_HAVE_ACCOUNT_QUESTION,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            InkWell(
                                child: Text(' ${AppConstant.LOGIN}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor)),
                                onTap: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          error ?? '',
                          style: TextStyle(color: Colors.red, fontSize: 15.0),
                        ),
                        SizedBox(height: 5.0),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Nomor Ponsel Orang tua/Wali',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.pink[300],
                              ),
                              child: CountryCodePicker(
                                textStyle: TextStyle(color: Colors.white),
                                onInit: (value) {
                                  countryCode = value.toString();
                                },
                                onChanged: (value) {
                                  setState(() {
                                    countryCode = value.toString();
                                  });
                                },
                                initialSelection: _isoCountryCode ?? "ID",
                                showOnlyCountryWhenClosed: false,
                              ),
                            ),
                            Expanded(
                              child: TextFormCustom(
                                keyboardType: TextInputType.phone,
                                hintText: '87654321',
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: 'Masukan No. Ponsel!'),
                                  MaxLengthValidator(13,
                                      errorText: 'No. Ponsel terlalu panjang'),
                                ]),
                                onChanged: (val) {
                                  setState(() {
                                    phoneNumber = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ButtonCustom(
                          child: !loading
                              ? Text(
                                  AppConstant.SIGN_UP,
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
                          onPressed: !loading
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    dismissKeyboard(context);
                                    setState(() {
                                      loading = true;
                                    });
                                    var phone = phoneNumber!;
                                    if (phone[0] == '0') {
                                      phone = phone.substring(1);
                                    }
                                    var codePhoneNumber = countryCode! + phone;
                                    _auth
                                        .checkUserExists(codePhoneNumber)
                                        .then((value) {
                                      if (value) {
                                        snackbarCustom(
                                                'Nomor sudah terdaftar, Silahkan login')
                                            .show(context);
                                        setState(() {
                                          loading = false;
                                        });
                                      } else {
                                        try {
                                          _auth.verifyPhoneNumber(
                                              codePhoneNumber,
                                              context,
                                              codeSent,
                                              verificationfailed);
                                        } catch (e) {
                                          loading = false;
                                          snackbarCustom(
                                                  'Terjadi kesalahan, coba sesaat lagi!')
                                              .show(context);
                                        }
                                      }
                                    });
                                  }
                                }
                              : null,
                        ),
                        SizedBox(height: 10),
                        // ButtonCustom(
                        //     child: Text(
                        //       "Daftar dengan Email",
                        //       style: TextStyle(
                        //           fontSize: 15.0, color: Colors.white),
                        //     ),
                        //     onPressed: () => Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 RegistrationEmailPage()))),
                      ]),
                    ),
                  )),
            )),
      ),
    );
  }
}
