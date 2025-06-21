import 'package:flutter/material.dart';

class NavigateAccountsWidget extends StatelessWidget {
  const NavigateAccountsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("/accounts");
          },
          child: Container(
            color: Colors.transparent,
            height: 30,
            child: const Row(
              children: [
                Text(
                  "내 계좌 목록",
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
