import 'package:flutter/material.dart';

import '../../../../core/widgets/common/common_border.widget.dart';

class NavigateAllReviewsWidget extends StatelessWidget {
  const NavigateAllReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("/all_reviews");
          },
          child: Container(
            color: Colors.transparent,
            height: 30,
            child: const Row(
              children: [
                Text(
                  "내 리뷰 목록",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
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
        const SizedBox(height: 10),
        const CommonBorder(color: Colors.grey),
      ],
    );
  }
}
