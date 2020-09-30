import 'package:e_imunisasi/pages/authpage/forgotpassword.dart';
import 'package:e_imunisasi/pages/authpage/registerpageAnak.dart';
import 'package:e_imunisasi/pages/authpage/registerpageMedis.dart';
import 'package:e_imunisasi/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget anakButton = FlatButton(
      child: Text("Anak/Balita"),
      onPressed: () {
        // widget.toggleViewAnak();
        Navigator.of(context).pop();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Register()));
      },
    );
    Widget medisButton = FlatButton(
      child: Text("Tenaga Kesehatan"),
      onPressed: () {
        // widget.toggleViewMedis();
        Navigator.of(context).pop();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterMedis()));
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Kembali"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 5.0,
      title: Text("Daftar Sebagai?"),
      content: Text(
          "Anda dapat mendaftar sebagai Anak/Balita dan Tenaga kesehatan."),
      actions: [
        anakButton,
        medisButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //Email and Pass state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 50.0),
              child: KeyboardAvoider(
                  // autoScroll: true,
                  child: Form(
                key: _formKey,
                child: Column(children: [
                  Text("Hello",
                      style: TextStyle(
                        fontFamily: 'orchide',
                        fontSize: 200.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      )),
                  Text("E-IMUNISASI APP",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w300,
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("Silahkan Login",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w300,
                      )),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                  SizedBox(height: 1.0),
                  Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.email),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                        filled: true,
                        hintText: 'Example@gmail.com',
                        labelText: 'Email',
                      ),
                      validator: (val) => val.isEmpty ? 'Masukkan Email' : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      onFieldSubmitted: (value) async {
                        if (_formKey.currentState.validate()) {
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() => error = "Email atau Password Salah");
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.remove_red_eye),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                        filled: true,
                        labelText: 'Password',
                      ),
                      validator: (val) => val.length < 8
                          ? 'Masukan Password Minimal 8 Karakter'
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      onFieldSubmitted: (value) async {
                        if (_formKey.currentState.validate()) {
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() => error = "Email atau Password Salah");
                          }
                        }
                      },
                    ),
                  ),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                        FlatButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPage()));
                          },
                          child: Text(
                            "Lupa Password",
                            textAlign: TextAlign.start,
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.black),
                          ),
                        )
                      ])),
                  SizedBox(
                    height: 1.0,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: FlatButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() => error = "Email atau Password Salah");
                          }
                        }
                      },
                      color: Colors.blue,
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.0,
                  ),
                  // Container(
                  //     // decoration: BoxDecoration(
                  //     //     color: Colors.blue,
                  //     //     borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  //     child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SignInButton(
                  //       Buttons.Facebook,
                  //       mini: true,
                  //       text: "Login dengan Facebook",
                  //       onPressed: () {},
                  //     ),
                  //     SizedBox(
                  //       height: 5.0,
                  //     ),
                  //     SignInButton(
                  //       Buttons.Google,
                  //       text: "Login dengan Google",
                  //       onPressed: () {},
                  //     ),
                  //   ],
                  // )),
                  // SizedBox(
                  //   height: 1.0,
                  // ),
                  Container(
                    child: FlatButton(
                      onPressed: () {
                        showAlertDialog(context);
                      },
                      child: Text(
                        "Belum punya akun? Klik disini",
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                ]),
              )))),
    );
  }
}
