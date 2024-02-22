import 'package:flutter/material.dart';
export 'package:snack/snack.dart';

SnackBar snackbarCustom(String? text) => SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Text(
        text.toString(),
        style: TextStyle(fontFamily: 'Nunito'),
      ),
      backgroundColor: Colors.pink[300],
    );
