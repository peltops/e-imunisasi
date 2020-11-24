import 'package:flutter/material.dart';

var badgenotif = Positioned(
  top: 5.0,
  right: 5.0,
  child: Container(
    padding: EdgeInsets.all(1.0),
    decoration: BoxDecoration(color: Colors.deepOrange, shape: BoxShape.circle),
    constraints: BoxConstraints(minWidth: 15.0, minHeight: 15.0),
    child: Center(
      child: Text(
        "10",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
      ),
    ),
  ),
);
