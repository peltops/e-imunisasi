import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/auth.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_signin_button/flutter_signin_button.dart';

class ResetpasswordPage extends StatefulWidget {
  @override
  _ResetpasswordPageState createState() => _ResetpasswordPageState();
}

class _ResetpasswordPageState extends State<ResetpasswordPage> {
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
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        Text("Lupa Kata Sandi",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
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
                            EmailValidator(
                                errorText: 'Masukan email yang valid'),
                            RequiredValidator(errorText: 'Masukan email'),
                          ]),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        ButtonCustom(
                          child: !loading
                              ? Text(
                                  "Kirim",
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
                                    try {
                                      await _auth.recoveryPassword(email);
                                      setState(() {
                                        error =
                                            'Link sudah dikirim. Silahkan cek email $email.';
                                      });
                                    } catch (e) {
                                      snackbarCustom("Gagal mengirim email")
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
    );
  }
}
