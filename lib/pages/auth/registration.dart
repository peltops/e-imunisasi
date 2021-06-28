import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/auth.dart';
import 'package:eimunisasi/utils/custom_validator.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:snack/snack.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

// import 'package:flutter_signin_button/flutter_signin_button.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //Email and Pass state
  bool loading = false;
  String firstName = "";
  String lastName = "";
  String phoneNumber = "";
  String email = "";
  String password = "";
  String error = "";
  bool _sandi = true;

  showHide() {
    setState(() {
      _sandi = !_sandi;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
            child: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: KeyboardAvoider(
                child: Column(children: [
                  Text("Daftarkan Akun",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sudah punya akun?",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                      InkWell(
                          child: Text(' Masuk',
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
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 15.0),
                  ),
                  SizedBox(height: 5.0),
                  TextFormCustom(
                    label: 'Nama Depan',
                    hintText: '',
                    icon: null,
                    validator: (val) =>
                        val.isEmpty ? 'Silahkan masukkan Nama Depan' : null,
                    onChanged: (val) {
                      setState(() {
                        firstName = val;
                      });
                    },
                  ),
                  TextFormCustom(
                    label: 'Nama Belakang',
                    hintText: '',
                    icon: null,
                    validator: (val) =>
                        val.isEmpty ? 'Silahkan masukkan Nama Belakang' : null,
                    onChanged: (val) {
                      setState(() {
                        lastName = val;
                      });
                    },
                  ),
                  TextFormCustom(
                    keyboardType: TextInputType.emailAddress,
                    label: 'Email',
                    hintText: '',
                    icon: null,
                    validator: MultiValidator([
                      EmailValidator(errorText: 'Masukan email yang valid'),
                      RequiredValidator(errorText: 'Masukan email'),
                    ]),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  TextFormCustom(
                    keyboardType: TextInputType.phone,
                    label: 'No. Handphone',
                    hintText: '',
                    icon: null,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Masukan No. Handphone'),
                      MaxLengthValidator(15,
                          errorText: 'No.Handphone terlalu panjang'),
                      CPhoneValidator(errorText: 'No.Handphone dimulai +62')
                    ]),
                    onChanged: (val) {
                      setState(() {
                        phoneNumber = val;
                      });
                    },
                  ),
                  TextFormCustom(
                    label: 'Password',
                    hintText: '',
                    obscureText: _sandi,
                    icon: IconButton(
                      icon: Icon(
                          _sandi ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => showHide(),
                    ),
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Masukan password'),
                      MinLengthValidator(8,
                          errorText: 'Password minimal 8 karakter'),
                    ]),
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  buttonCustom(
                    textChild: !loading
                        ? Text(
                            "Daftar",
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.white),
                          )
                        : SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                    onPressed: !loading
                        ? () async {
                            if (_formKey.currentState.validate()) {
                              dismissKeyboard(context);
                              setState(() {
                                loading = true;
                              });
                              try {
                                await _auth.signUp(email, password,
                                    firstName: firstName,
                                    lastName: lastName,
                                    phoneNumber: phoneNumber);
                                Navigator.pop(context);
                              } catch (e) {
                                snackbarCustom(e.message.toString())
                                    .show(context);
                              } finally {
                                setState(() {
                                  loading = false;
                                });
                              }
                            }
                          }
                        : null,
                  ),
                ]),
              ),
            )),
          )),
        ),
      ),
    );
  }
}
