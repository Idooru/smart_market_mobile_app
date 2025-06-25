import 'package:flutter/material.dart';

import '../../../../core/widgets/dialog/warn_dialog.dart';

class GoOutReviewDialog {
  static void show(
    BuildContext context, {
    required String title,
    required List<Widget> buttons,
  }) {
    WarnDialog.show(
      context,
      title: title,
      buttons: buttons,
    );
  }
}
