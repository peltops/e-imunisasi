import 'package:e_imunisasi/pages/notifpage/notifpage.dart';
import 'package:e_imunisasi/pages/profilepage/widget/profile_card.dart';
import 'package:e_imunisasi/pages/widget/badge.dart';
import 'package:e_imunisasi/services/auth.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  // bool isVerified = false;
  final AuthService _auth = AuthService();

  // void get _displaySnackbar {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(
  //       duration: Duration(days: 365),
  //       content: Text('Silahkan verifikasi email anda')));
  // }

  // cekVerified() async {
  //   dynamic result = await _auth.cekVerifiedEmail();
  //   setState(() {
  //     isVerified = result.isEmailVerified;
  //   });
  //   return !isVerified
  //       ? Future.delayed(Duration(seconds: 1)).then((_) => _displaySnackbar)
  //       : null;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   cekVerified();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Stack(
            children: [
              badgenotif,
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NotifPage()));
                  },
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.deepOrange,
                  )),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          ProfileCard(),
          FlatButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              onPressed: () async {
                await _auth.signOut();
              },
              color: Colors.deepOrange,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              label: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              )),
          // !isVerified
          //     // ? Scaffold.of(context).showSnackBar(snackBar)
          //     : Text("Terverifikasi"),
        ],
      ),
    );
  }
}
