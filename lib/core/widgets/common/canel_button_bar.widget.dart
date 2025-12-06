import 'package:flutter/cupertino.dart';

import '../../themes/color.dart';
import 'common_button_bar.widget.dart';

class CancelButtonBarWidget extends StatelessWidget {
  const CancelButtonBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonButtonBarWidget(
      backgroundColor: negativeButtonBackgroundColor,
      title: Text(
        "취소",
        style: TextStyle(
          color: negativeButtonTextColor,
          fontSize: 16,
        ),
      ),
      pressCallback: () => Navigator.of(context).pop(),
    );
  }
}
