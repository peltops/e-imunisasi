import 'package:flutter/material.dart';

class VerticalSpacer extends StatelessWidget {
  const VerticalSpacer({Key? key, this.val = 10}) : super(key: key);
  final double val;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: val,
    );
  }
}

class HorizontalSpacer extends StatelessWidget {
  const HorizontalSpacer({Key? key, this.val = 10}) : super(key: key);
  final double val;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: val,
    );
  }
}
