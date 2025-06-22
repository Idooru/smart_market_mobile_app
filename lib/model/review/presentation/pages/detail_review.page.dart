import 'package:flutter/material.dart';

import '../../../../core/themes/theme_data.dart';

class DetailReviewPageArgs {
  final String reviewId;

  const DetailReviewPageArgs({
    required this.reviewId,
  });
}

class DetailReviewPage extends StatefulWidget {
  final String reviewId;

  const DetailReviewPage({
    super.key,
    required this.reviewId,
  });

  @override
  State<DetailReviewPage> createState() => _DetailReviewPageState();
}

class _DetailReviewPageState extends State<DetailReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail"),
        flexibleSpace: appBarColor,
      ),
      body: const Padding(
        padding: EdgeInsets.all(10),
      ),
    );
  }
}
