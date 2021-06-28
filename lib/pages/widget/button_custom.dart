import 'package:flutter/material.dart';

buttonCustom({
  Widget textChild,
  Function onPressed,
}) {
  return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(4, 2),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.pink[300], Colors.pink[400]])),
      child: TextButton(
        onPressed: onPressed,
        child: textChild,
      ));
}
