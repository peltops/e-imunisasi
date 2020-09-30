import 'package:flutter/material.dart';

class NotifPage extends StatefulWidget {
  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Notifikasi")),
        body: Container(
            child: Center(
          child: Text("NOTIFIKASI"),
        )));
  }
}
