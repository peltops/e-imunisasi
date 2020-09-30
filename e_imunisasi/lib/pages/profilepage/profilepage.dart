import 'package:e_imunisasi/pages/profilepage/personalpage.dart';
import 'package:flutter/material.dart';
import 'package:e_imunisasi/services/auth.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 50.0),
        child: Align(
            alignment: Alignment.center,
            child: Column(children: [
              Text(
                "PROFILE",
                textAlign: TextAlign.center,
              ),
              FlatButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  color: Colors.blue,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PersonalPage()));
                  },
                  color: Colors.blue,
                  icon: Icon(
                    Icons.person_pin,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Personal Data",
                    style: TextStyle(color: Colors.white),
                  ))
            ])));
  }
}
