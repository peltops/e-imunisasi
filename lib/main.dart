import 'package:eimunisasi/pages/splash/splash.dart';
import 'package:eimunisasi/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users>.value(
      value: AuthService().userActive,
      builder: (context, snapshot) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.pink[300],
            primarySwatch: Colors.pink,
            accentColor: Colors.pink[400],
            fontFamily: 'Nunito',
          ),
          home: Splash(),
        );
      },
      initialData: null,
    );
  }
}
