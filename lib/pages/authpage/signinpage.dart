import 'package:e_imunisasi/pages/authpage/Widget/bezierContainer.dart';
import 'package:e_imunisasi/pages/authpage/forgotpassword.dart';
import 'package:e_imunisasi/pages/authpage/registerpage.dart';
import 'package:e_imunisasi/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'e ',
          style: GoogleFonts.portLligatSans(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'Imun',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'isas',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
            TextSpan(
              text: 'i',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Positioned(
            top: -height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child: BezierContainer()),
        Center(
            child: Container(
          padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 30.0),
          child: SingleChildScrollView(
              child: KeyboardAvoider(
                  child: Form(
            key: _formKey,
            child: Column(children: [
              _title(),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Silahkan Login",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        // color: Color(0xffe46b10),
                        fontSize: 25.0,
                        fontWeight: FontWeight.w700,
                      )),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.email,
                    ),
                    fillColor: Color(0xfff3f3f4),
                    border: InputBorder.none,
                    filled: true,
                    hintText: 'example@gmail.com',
                  ),
                  validator: (val) => val.isEmpty ? 'Masukkan Email' : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                          _sandi ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => showHide(),
                    ),
                    fillColor: Color(0xfff3f3f4),
                    border: InputBorder.none,
                    filled: true,
                    hintText: "password",
                  ),
                  validator: (val) =>
                      val.length < 8 ? 'Masukan Password' : null,
                  obscureText: _sandi,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
              ),
              Container(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(padding: EdgeInsets.all(20.0)),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ForgotPage()));
                  },
                  child: Text(
                    "Lupa Password?",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15.0, color: Colors.black),
                  ),
                )
              ])),
              SizedBox(
                height: 1.0,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(4, 2),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                child: FlatButton(
                  onPressed: !loading
                      ? () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = "Email atau Password Salah";
                              });
                            }
                          }
                        }
                      : null,
                  child: !loading
                      ? Text(
                          "Login",
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                        )
                      : SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun?"),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: () {
                        registerAlertDialog(context);
                      },
                      child: Text(
                        "Klik disini",
                        style:
                            TextStyle(fontSize: 15.0, color: Color(0xffe46b10)),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ))),
        ))
      ]),
    );
  }

  registerAlertDialog(BuildContext context) {
    // set up the buttons
    Widget anakButton = FlatButton(
      child: Text("Anak/Balita"),
      onPressed: () {
        // widget.toggleViewAnak();
        Navigator.of(context).pop();
        final String typeRegis = 'anakCollection';
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Register(typeRegis: typeRegis)));
      },
    );
    Widget medisButton = FlatButton(
      child: Text("Tenaga Kesehatan"),
      onPressed: () {
        // widget.toggleViewMedis();
        Navigator.of(context).pop();
        final String typeRegis = 'medisCollection';
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Register(typeRegis: typeRegis)));
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

  lupaPassAlertDialog(BuildContext context) {
    // set up the buttons
    Widget forgotButton = Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(4, 2),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
      child: FlatButton(
        onPressed: !loading
            ? () async {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    loading = true;
                  });
                  dynamic result = await _auth.recoveryPassword(email);
                  Navigator.of(context).pop();
                  if (result == null) {
                    setState(() {
                      loading = false;
                      error = "Terjadi keselahan saat mengirim email";
                    });
                  }
                }
              }
            : null,
        child: !loading
            ? Text(
                "Kirim Email",
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              )
            : SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
      ),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 5.0,
      actionsPadding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 30.0),
      title: Text("Lupa Password"),
      content: TextFormField(
        decoration: InputDecoration(
          fillColor: Color(0xfff3f3f4),
          border: InputBorder.none,
          filled: true,
          labelText: 'Masukkan Email',
          hintText: 'example@gmail.com',
        ),
        validator: (val) => val.isEmpty ? 'Masukkan Email' : null,
        onChanged: (val) {
          setState(() {
            email = val;
          });
        },
      ),
      actions: [
        forgotButton,
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
}
