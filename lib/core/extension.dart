import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  bool get isNullOrEmpty {
    return this.isEmpty;
  }

  bool get isNotNullOrEmpty {
    return this.isNotEmpty;
  }
}

const String emptyString = '';

extension Navigate on BuildContext {
  void navigateTo(Widget widget) {
    Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }
}
