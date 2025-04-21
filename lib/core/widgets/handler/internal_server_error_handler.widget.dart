import 'package:flutter/material.dart';

class InternalServerErrorHandlerWidget extends StatelessWidget {
  const InternalServerErrorHandlerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 45,
            color: Colors.red,
          ),
          SizedBox(height: 5),
          Text(
            "현재 서버에 치명적인 에러가 발생하였습니다.",
            style: TextStyle(
              color: Color.fromARGB(255, 70, 70, 70),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "죄송합니다. 나중에 다시 시도해주세요.",
            style: TextStyle(
              color: Color.fromARGB(255, 70, 70, 70),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
