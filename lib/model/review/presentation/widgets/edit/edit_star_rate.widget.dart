import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smart_market/core/themes/theme_data.dart';

class EditStarRateWidget extends StatefulWidget {
  const EditStarRateWidget({super.key});

  @override
  State<EditStarRateWidget> createState() => EditStarRateWidgetState();
}

class EditStarRateWidgetState extends State<EditStarRateWidget> {
  double rating = 5.0;
  int selectedRating = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: commonContainerDecoration,
      child: Row(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 5),
              child: Text(
                "별점",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 25,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.red,
                ),
                onRatingUpdate: (newRating) {
                  setState(() {
                    rating = newRating;
                    selectedRating = newRating.toInt();
                  });
                  debugPrint("rating: $rating");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
