import 'package:flutter/material.dart';

class ConditionalButtonBarWidget extends StatelessWidget {
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
    return GestureDetector(
      onTap: isValid ? pressCallback : () {},
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isValid ? getBackgroundColorWhenValid() : const Color.fromARGB(255, 190, 190, 190),
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
