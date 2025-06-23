import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/model/media/presentation/provider/review_image.provider.dart';
import 'package:smart_market/model/review/presentation/widgets/item/review_image_area.widget.dart';
import 'package:smart_market/model/review/presentation/widgets/item/review_video_area.widget.dart';

import '../../../../media/presentation/provider/review_video.provider.dart';

class EditReviewMediaWidget extends StatefulWidget {
  final List<String>? beforeImageUrls;
  final List<String>? beforeVideoUrls;

  const EditReviewMediaWidget({
    super.key,
    this.beforeImageUrls,
    this.beforeVideoUrls,
  });

  @override
  State<EditReviewMediaWidget> createState() => _EditReviewMediaWidgetState();
}

class _EditReviewMediaWidgetState extends State<EditReviewMediaWidget> {
  late final ReviewImageProvider _imageProvider;
  late final ReviewVideoProvider _videoProvider;

  @override
  void initState() {
    super.initState();
    _imageProvider = context.read<ReviewImageProvider>();
    _videoProvider = context.read<ReviewVideoProvider>();
  }

  @override
  void dispose() {
    _imageProvider.clearAll();
    _videoProvider.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: commonContainerDecoration,
          height: 430,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  "미디어 첨부",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              ReviewImageAreaWidget(
                provider: _imageProvider,
                beforeImageUrls: widget.beforeImageUrls,
              ),
              const SizedBox(height: 15),
              ReviewVideoAreaWidget(
                provider: _videoProvider,
                beforeVideoUrls: widget.beforeVideoUrls,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
