import 'package:eimunisasi/models/user.dart';
import 'package:eimunisasi/pages/auth/login.dart';
import 'package:eimunisasi/pages/local_auth/passcode_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    if (user == null) {
      return LoginPage();
    } else {
      return PasscodePage();
    }
  }
}
