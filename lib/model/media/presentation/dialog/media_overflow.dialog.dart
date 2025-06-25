import 'package:flutter/material.dart';
import 'package:smart_market/core/widgets/dialog/warn_dialog.dart';

class MediaOverflowDialog {
  static void show(BuildContext context, {required String title}) {
    WarnDialog.show(context, title: title, buttons: []);
  }
}
