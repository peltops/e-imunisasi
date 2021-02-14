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
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            "Notifikasi",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
            child: Center(
          child: Text("KOSONG"),
        )));
  }
}
