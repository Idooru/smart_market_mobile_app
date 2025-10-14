import 'package:flutter/material.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.mixin.dart';

class CommonButtonBarWidget extends StatelessWidget with CommonButtonBar {
  final IconData? icon;
  final Color? backgroundColor;
  final String title;
  final void Function() pressCallback;

  const CommonButtonBarWidget({
    super.key,
    this.icon,
    this.backgroundColor,
    required this.title,
    required this.pressCallback,
  });

  Color getBackgroundColor() {
    return backgroundColor != null ? backgroundColor! : Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: pressCallback,
      style: getButtonStyle(getBackgroundColor()),
      child: getButtonContent(icon, title),
    );
  }
}
