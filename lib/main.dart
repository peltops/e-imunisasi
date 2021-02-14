import 'package:e_imunisasi/pages/wrapper.dart';
import 'package:e_imunisasi/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_imunisasi/models/user.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.deepOrange,
          primarySwatch: Colors.deepOrange,
          fontFamily: 'googlefont',
        ),
        home: Splash(),
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: new Wrapper(),
      image: Image.asset('assets/img/logo.png'),
      photoSize: 100.0,
    );
  }
}
