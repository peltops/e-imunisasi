import 'package:eimunisasi/features/authentication/presentation/screens/auth/login_phone_screen.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:eimunisasi/pages/local_auth/passcode_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    if (user == null) {
      return LoginPhoneScreen();
    } else {
      return PasscodePage();
    }
  }
}
