import 'package:eimunisasi/pages/onboarding/onboarding.dart';
import 'package:eimunisasi/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('isSplashSeen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => Wrapper()));
    } else {
      await prefs.setBool('isSplashSeen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => Onboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 80,
              ),
            ],
          )),
    ));
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();
}
