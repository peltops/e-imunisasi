import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final Widget child;
  final Function? onPressed;
  final bool loading;
  const ButtonCustom({
    Key? key,
    required this.child,
    required this.onPressed,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnable = onPressed != null || loading;
    return Container(
        width: double.infinity,
        decoration: isEnable
            ? BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(4, 2),
                    blurRadius: 5,
                    spreadRadius: 2,
                  )
                ],
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.pink[300]!, Colors.pink[400]!]))
            : BoxDecoration(color: Colors.grey[300]),
        child: TextButton(
          onPressed: !loading ? onPressed as void Function()? : null,
          child: loading
              ? SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : child,
        ));
  }
}
