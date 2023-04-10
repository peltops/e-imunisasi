import 'package:country_code_picker/country_code_picker.dart';
import 'package:eimunisasi/pages/auth/login_email.dart';
import 'package:eimunisasi/pages/auth/otp_page.dart';
import 'package:eimunisasi/pages/auth/registration.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/auth.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:sim_info/sim_info.dart';

// import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  final Function? toggleView;
  LoginPage({this.toggleView});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _phoneController = TextEditingController();
  bool loading = false;
  String error = '';
  final _formKey = GlobalKey<FormState>();
  late String countryCode;

// siminfo
  String? _isoCountryCode;

  Future<void> getSimInfo() async {
    String isoCountryCode = await SimInfo.getIsoCountryCode;

    setState(() {
      _isoCountryCode = isoCountryCode;
    });
  }

  @override
  void initState() {
    getSimInfo();
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
    };
    final PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) {
      setState(() {
        loading = false;
      });
      var phone = _phoneController.text.trim();
      if (phone[0] == '0') {
        phone = phone.substring(1);
      }
      phone = countryCode + phone;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => OTPPage(
                    phoneNumber: phone,
                    verId: verificationId,
                    description: 'login',
                  )),
          (route) => false);
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
                  child: Column(children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text("Silahkan Masuk",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pengguna baru?",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                        InkWell(
                            child: Text(' Buat akun',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationPage()));
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    error.isNotEmpty
                        ? Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 15.0),
                          )
                        : Container(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Nomor Ponsel',
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
                            ]) as Function?,
                            controller: _phoneController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ButtonCustom(
                      child: !loading
                          ? Text(
                              "Masuk",
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.white),
                            )
                          : SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                      onPressed: () {
                        dismissKeyboard(context);
                        if (_formKey.currentState!.validate()) {
                          var phone = _phoneController.text.trim();
                          if (phone[0] == '0') {
                            phone = phone.substring(1);
                          }
                          phone = countryCode + phone;
                          setState(() {
                            loading = true;
                          });
                          _auth.checkUserExists(phone).then((value) {
                            if (value) {
                              try {
                                AuthService().verifyPhoneNumber(
                                  phone,
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
                            } else {
                              snackbarCustom(
                                      'Nomor tidak terdaftar, Silahkan daftar terlebih dahulu!')
                                  .show(context);
                              setState(() {
                                loading = false;
                              });
                            }
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    ButtonCustom(
                        child: Text(
                          "Masuk dengan Email",
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPageEmail()))),
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
