import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/model/media/presentation/provider/review_image.provider.dart';
import 'package:smart_market/model/review/presentation/widgets/item/review_image_area.widget.dart';
import 'package:smart_market/model/review/presentation/widgets/item/review_video_area.widget.dart';

import '../../../../media/presentation/provider/review_video.provider.dart';

class EditReviewMediaWidget extends StatelessWidget {
  const EditReviewMediaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ReviewImageProvider, ReviewVideoProvider>(
      builder: (
        BuildContext context,
        ReviewImageProvider reviewImageProvider,
        ReviewVideoProvider reviewVideoProvider,
        Widget? child,
      ) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: commonContainerDecoration,
              height: 430,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "미디어 첨부",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  ReviewImageAreaWidget(),
                  SizedBox(height: 15),
                  ReviewVideoAreaWidget(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
