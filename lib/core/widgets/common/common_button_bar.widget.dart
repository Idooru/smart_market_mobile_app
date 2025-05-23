import 'package:flutter/material.dart';

class CommonButtonBarWidget extends StatelessWidget {
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
    return GestureDetector(
      onTap: pressCallback,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
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
        ),
      ),
    );
  }
}
