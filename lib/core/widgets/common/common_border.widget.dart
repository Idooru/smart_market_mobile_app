import 'package:flutter/material.dart';

class CommonBorder extends StatelessWidget {
  final Color color;
  final double width;

  const CommonBorder({
    super.key,
    this.color = Colors.black,
    this.width = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
      ),
    );
  }
}
