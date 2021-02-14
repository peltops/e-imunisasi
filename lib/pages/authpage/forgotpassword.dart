import 'package:e_imunisasi/pages/authpage/Widget/bezierContainer.dart';
import 'package:e_imunisasi/services/auth.dart';
import 'package:flutter/material.dart';

class ForgotPage extends StatefulWidget {
  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  //Email and Pass state
  bool loading = false;
  String email = "";
  String status = "";
  String error = "";

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 5.0,
      title: Text("Reset Password"),
      content: Text("Password reset link telah dikirim ke email."),
      actions: [
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            "Lupa Password",
            style: TextStyle(color: Colors.black),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Center(
              child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 7 - .0, horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                          key: _formKey,
                          child: Column(children: [
                            error == null
                                ? Text(
                                    status,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14.0),
                                  )
                                : Text(
                                    error,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14.0),
                                  ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
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
                                validator: (val) =>
                                    val.isEmpty ? 'Masukkan Email' : null,
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
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
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
                                      colors: [
                                        Color(0xfffbb448),
                                        Color(0xfff7892b)
                                      ])),
                              child: FlatButton(
                                onPressed: !loading
                                    ? () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          await _auth.recoveryPassword(email);
                                          setState(() {
                                            status =
                                                "Silahkan cek email $email";
                                          });
                                          registerAlertDialog(context, email);
                                        }
                                        return {
                                          // error = "Gagal mengirim email $email",
                                          loading = false,
                                          null
                                        };
                                      }
                                    : null,
                                child: Text(
                                  "Kirim Email",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              ),
                            ),
                          ])),
                    ],
                  )),
            ),
          ],
        ));
  }

  registerAlertDialog(BuildContext context, String email) {
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 5.0,
      content: Text("Silahkan cek email $email."),
      actions: [
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
}
