import 'package:flutter/material.dart';

class NavigateOrdersWidget extends StatelessWidget {
  const NavigateOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("/orders");
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.transparent,
            height: 30,
            child: const Row(
              children: [
                Text(
                  "내 결제 목록",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 65, 65, 65)),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_right,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
