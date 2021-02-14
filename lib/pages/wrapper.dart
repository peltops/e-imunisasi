import 'package:e_imunisasi/pages/authpage/signinpage.dart';
import 'package:e_imunisasi/pages/homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_imunisasi/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //return page
    if (user == null) {
      return SignInPage();
    } else {
      return Homepage();
    }
  }
}
