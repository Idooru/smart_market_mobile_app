import 'package:flutter/material.dart';

mixin CommonButtonBar {
  ButtonStyle getButtonStyle(Color backgroundColor) {
    return ElevatedButton.styleFrom(
      minimumSize: const Size(0, 50),
      backgroundColor: backgroundColor,
      foregroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Row getButtonContent(IconData? icon, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon != null
            ? Row(
                children: [
                  Icon(
                    icon,
                    size: 19,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                ],
              )
            : const SizedBox.shrink(),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        )
      ],
    );
  }
}
