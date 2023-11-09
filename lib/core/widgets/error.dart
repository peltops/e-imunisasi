import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/core/widgets/spacer.dart';
import 'package:eimunisasi/core/widgets/text.dart';
import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  final VoidCallback? onRefresh;
  const ErrorContainer({Key? key, this.onRefresh}) : super(key: key);

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
            text: AppConstant.ERROR_OCCURRED,
          ),
          VerticalSpacer(),
          InkWell(
            onTap: onRefresh,
            child: Text(AppConstant.TRY_AGAIN),
          ),
        ],
      ),
    );
  }
}
