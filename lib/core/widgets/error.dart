import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/core/widgets/spacer.dart';
import 'package:eimunisasi/core/widgets/text.dart';
import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  final VoidCallback? onRefresh;
  final String? message;
  final String? title;
  const ErrorContainer({
    Key? key,
    this.onRefresh,
    this.message,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          VerticalSpacer(),
          TitleText(
            text: title ?? AppConstant.ERROR_OCCURRED,
          ),
          VerticalSpacer(),
          InkWell(
            onTap: onRefresh,
            child: Text(
              message ?? AppConstant.TRY_AGAIN,
            ),
          ),
        ],
      ),
    );
  }
}
