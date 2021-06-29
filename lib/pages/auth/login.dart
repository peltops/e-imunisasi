import 'package:eimunisasi/pages/auth/registration.dart';
import 'package:eimunisasi/pages/auth/resetpassword.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/auth.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:snack/snack.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:form_field_validator/form_field_validator.dart';

// import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  final Function toggleView;
  LoginPage({this.toggleView});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //Email and Pass state
  bool loading = false;
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
                                    builder: (context) => RegistrationPage()));
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
                    label: 'Email',
                    hintText: 'contoh@gmail.com',
                    icon: Icon(Icons.email),
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
                    label: 'Password',
                    hintText: 'password',
                    obscureText: _sandi,
                    icon: IconButton(
                      icon: Icon(
                          _sandi ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => showHide(),
                    ),
                    validator: (val) =>
                        val.length < 8 ? 'Masukan Password min 8' : null,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          child: Text(' Lupa Kata Sandi?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              )),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetpasswordPage()));
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  buttonCustom(
                    textChild: !loading
                        ? Text(
                            "Masuk",
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
                                await _auth.signIn(email, password);
                                setState(() {
                                  loading = false;
                                });
                              } catch (e) {
                                snackbarCustom(e.message.toString())
                                    .show(context);
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
