import 'package:flutter/material.dart';

class InitFilterButtonBarWidget extends StatelessWidget {
  final VoidCallback pressInitFilter;

  const InitFilterButtonBarWidget({
    super.key,
    required this.pressInitFilter,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: pressInitFilter,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 180, 180, 180),
        foregroundColor: Colors.white,
        minimumSize: const Size(200, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        "필터링 초기화",
        style: TextStyle(
          color: Color.fromARGB(255, 70, 70, 70),
        ),
      ),
    );
  }
}
