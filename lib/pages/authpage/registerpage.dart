import 'package:e_imunisasi/pages/authpage/Widget/bezierContainer.dart';
import 'package:flutter/material.dart';
import 'package:e_imunisasi/services/auth.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class Register extends StatefulWidget {
  final String typeRegis;

  Register({this.typeRegis});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //Email and Pass state
  String nama = "";
  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          title: widget.typeRegis == 'anakCollection'
              ? Text("Daftar Sebagai Anak",
                  style: TextStyle(color: Colors.black))
              : Text(
                  "Daftar Sebagai Tenaga Kesehatan",
                  style: TextStyle(color: Colors.black),
                ),
        ),
        body: Stack(children: [
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Center(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 90.0, horizontal: 30.0),
                child: SingleChildScrollView(
                    child: KeyboardAvoider(
                        child: Form(
                  key: _formKey,
                  child: Column(children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Silahkan Isi Data Diri Anda",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              // color: Color(0xffe46b10),
                              fontSize: 25.0,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Nama Lengkap",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: TextFormField(
                          decoration: InputDecoration(
                            fillColor: Color(0xfff3f3f4),
                            border: InputBorder.none,
                            filled: true,
                            hintText: 'Nama Lengkap',
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Masukkan Nama Lengkap' : null,
                          onChanged: (val) {
                            setState(() {
                              nama = val;
                            });
                          }),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: TextFormField(
                          decoration: InputDecoration(
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
                          }),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: TextFormField(
                          decoration: InputDecoration(
                            fillColor: Color(0xfff3f3f4),
                            border: InputBorder.none,
                            filled: true,
                            hintText: 'Password',
                          ),
                          validator: (val) => val.length < 8
                              ? 'Masukan Password Minimal 8 Karakter'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          }),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Konfirmasi Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Color(0xfff3f3f4),
                          border: InputBorder.none,
                          filled: true,
                          hintText: 'Konfirmasi Password',
                        ),
                        validator: (val) => val != password || val == ""
                            ? 'Password Belum Sesuai'
                            : null,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
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
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          nama,
                                          email,
                                          password,
                                          widget.typeRegis);
                                  registerAlertDialog(context, email);
                                  if (result == null) {
                                    setState(() {
                                      loading = true;
                                      error = "Email Sudah Terdaftar";
                                    });
                                  }
                                }
                              }
                            : null,
                        child: !loading
                            ? Text(
                                "Daftar",
                                style: TextStyle(color: Colors.white),
                              )
                            : SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                      ),
                    ),
                  ]),
                )))),
          )
        ]));
  }

  registerAlertDialog(BuildContext context, String email) {
    // set up the buttons

    Widget cancelButton = FlatButton(
      child: Text("Kembali"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 5.0,
      title: Text("Terimakasih telah mendaftar"),
      content: Text("Silahkan verifikasi email: $email terlebih dahulu"),
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
