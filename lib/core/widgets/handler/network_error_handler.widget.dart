import 'package:flutter/material.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';

class NetworkErrorHandlerWidget extends StatefulWidget {
  final bool hasReturn;
  final void Function() reconnectCallback;

  const NetworkErrorHandlerWidget({
    super.key,
    required this.reconnectCallback,
    this.hasReturn = false,
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
          const Icon(
            Icons.signal_wifi_connected_no_internet_4,
            size: 37,
            color: Colors.red,
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CommonButtonBarWidget(
              icon: Icons.refresh,
              title: "재연결 시도",
              backgroundColor: Colors.black,
              pressCallback: () {
                widget.reconnectCallback();
              },
            ),
          ),
          const SizedBox(height: 10),
          if (widget.hasReturn)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CommonButtonBarWidget(
                icon: Icons.arrow_back_ios,
                title: "이전 페이지로 돌아가기",
                backgroundColor: const Color.fromARGB(255, 90, 90, 90),
                pressCallback: () => Navigator.of(context).pop(),
              ),
            ),
        ],
      ),
    );
  }
}
