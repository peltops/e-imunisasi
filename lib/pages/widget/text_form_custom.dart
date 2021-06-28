import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFormCustom extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final Widget icon;
  final Function validator;
  final Function onTap;
  final bool readOnly;
  final String initialValue;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function onChanged;
  TextFormCustom({
    this.label = 'label',
    this.hintText,
    this.icon,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
    this.obscureText = false,
    this.initialValue,
    this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        TextFormField(
          initialValue: initialValue,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            suffixIcon: icon,
            fillColor: Color(0xfff3f3f4),
            border: InputBorder.none,
            filled: true,
            hintText: hintText,
          ),
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          controller: controller,
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
