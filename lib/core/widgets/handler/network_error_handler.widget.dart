import 'package:flutter/material.dart';

class NetworkErrorHandlerWidget extends StatefulWidget {
  final void Function() reconnectCallback;

  const NetworkErrorHandlerWidget({
    super.key,
    required this.reconnectCallback,
  });

  @override
  State<NetworkErrorHandlerWidget> createState() => _NetworkErrorHandlerWidgetState();
}

class _NetworkErrorHandlerWidgetState extends State<NetworkErrorHandlerWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(
                Icons.warning_amber,
                size: 37,
                color: Colors.yellow,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "서버와의 연결이 원할하지 않습니다.",
            style: TextStyle(
              color: Color.fromARGB(255, 70, 70, 70),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              widget.reconnectCallback();
            },
            child: Container(
              width: 150,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "재연결 시도",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
