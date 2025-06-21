import 'package:flutter/material.dart';

class NavigateAllReviewsWidget extends StatelessWidget {
  const NavigateAllReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/all_reviews");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.transparent,
        height: 30,
        child: const Row(
          children: [
            Text(
              "내 리뷰 목록",
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
    );
  }
}
