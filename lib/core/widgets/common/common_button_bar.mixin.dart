import 'package:flutter/material.dart';

mixin CommonButtonBar {
  ButtonStyle getButtonStyle(Color enabledColor) {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(0, 50)),
      foregroundColor: MaterialStateProperty.all(Colors.black87),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return const Color.fromARGB(255, 190, 190, 190); // 비활성화
        }
        return enabledColor; // 활성화
      }),
    );
  }

  Row getButtonContent(IconData? icon, Widget title) {
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
        title,
      ],
    );
  }
}
