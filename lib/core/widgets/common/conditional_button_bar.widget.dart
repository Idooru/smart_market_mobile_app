import 'package:flutter/material.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.mixin.dart';

class ConditionalButtonBarWidget extends StatelessWidget with CommonButtonBar {
  final IconData? icon;
  final Color? backgroundColor;
  final String title;
  final bool isValid;
  final void Function() pressCallback;

  const ConditionalButtonBarWidget({
    super.key,
    this.icon,
    this.backgroundColor,
    required this.title,
    required this.isValid,
    required this.pressCallback,
  });

  Color getBackgroundColorWhenValid() {
    return backgroundColor != null ? backgroundColor! : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: pressCallback,
      style: getButtonStyle(isValid ? getBackgroundColorWhenValid() : const Color.fromARGB(255, 190, 190, 190)),
      child: getButtonContent(icon, title),
    );
  }
}
