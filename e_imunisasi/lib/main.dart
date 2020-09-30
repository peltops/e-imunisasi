import 'package:e_imunisasi/pages/wrapper.dart';
import 'package:e_imunisasi/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_imunisasi/models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'googlefont'),
        home: Wrapper(),
      ),
    );
  }
}
