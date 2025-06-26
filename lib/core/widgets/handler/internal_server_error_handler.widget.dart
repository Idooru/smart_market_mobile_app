import 'package:flutter/material.dart';
import 'package:smart_market/core/widgets/common/common_button_bar.widget.dart';

class InternalServerErrorHandlerWidget extends StatelessWidget {
  final bool hasReturn;

  const InternalServerErrorHandlerWidget({
    super.key,
    this.hasReturn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            size: 45,
            color: Colors.red,
          ),
          const SizedBox(height: 10),
          const Text(
            "현재 서버에 치명적인 에러가 발생하였습니다.",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "죄송합니다. 나중에 다시 시도해주세요.",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (hasReturn)
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
