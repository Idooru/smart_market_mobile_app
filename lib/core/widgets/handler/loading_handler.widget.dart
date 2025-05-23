import 'package:flutter/material.dart';

class LoadingHandlerWidget extends StatelessWidget {
  final String title;

  const LoadingHandlerWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.black),
          const SizedBox(width: 15),
          Text(
            title.length > 20 ? '${title.substring(0, 15)}\n${title.substring(15)}' : title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
