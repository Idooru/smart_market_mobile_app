import 'package:flutter/material.dart';

class DisplayAverageScoreWidget extends StatelessWidget {
  final double averageScore;

  const DisplayAverageScoreWidget({
    super.key,
    required this.averageScore,
  });

  @override
  Widget build(BuildContext context) {
    int fullStars = averageScore.floor();
    bool hasHalfStar = (averageScore - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    List<Widget> stars = [];

    // 꽉 찬 별 (빨강)
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, size: 15, color: Colors.red));
    }

    // 반 별 (빨강)
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, size: 15, color: Colors.red));
    }

    // 빈 별 (회색)
    for (int i = 0; i < emptyStars; i++) {
      stars.add(const Icon(Icons.star_border, size: 15, color: Colors.red));
    }

    return Row(children: stars);
  }
}
