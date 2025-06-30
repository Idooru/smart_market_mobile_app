import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/parse_date.dart';
import 'package:smart_market/model/media/domain/entities/file_source.entity.dart';
import 'package:smart_market/model/product/domain/entities/detail_product.entity.dart';
import 'package:smart_market/model/product/presentation/widgets/display_average_score.widget.dart';
import 'package:smart_market/model/user/utils/get_user_info.dart';

import '../../../../media/presentation/dialog/expand_image.dialog.dart';
import '../../../../user/domain/entities/user_info.entity.dart';
import '../../pages/detail_review/detail_review.page.dart';

class ReviewItemWidget extends StatefulWidget {
  final Review review;
  final Product product;
  final EdgeInsets margin;
  final void Function() updateCallback;

  const ReviewItemWidget({
    super.key,
    required this.review,
    required this.product,
    required this.margin,
    required this.updateCallback,
  });

  @override
  State<ReviewItemWidget> createState() => _ReviewItemWidgetState();
}

class _ReviewItemWidgetState extends State<ReviewItemWidget> {
  final TextStyle detailTextStyle = const TextStyle(fontSize: 12, color: Color.fromARGB(255, 90, 90, 90));

  bool isTapped = false;

  bool isYourReview() {
    UserInfo userInfo = getUserInfo();
    return userInfo.nickName == widget.review.nickName;
  }

  void pressTrailingIcon() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: isYourReview()
                    ? () async {
                        NavigatorState navigator = Navigator.of(context);
                        navigator.pop();

                        Object? result = await navigator.pushNamed(
                          "/detail_review",
                          arguments: DetailReviewPageArgs(
                            reviewId: widget.review.id,
                            productId: widget.product.id,
                            productName: widget.product.name,
                          ),
                        );

                        if (result == true) {
                          widget.updateCallback();
                          navigator.popUntil(ModalRoute.withName("/detail_product"));
                        }
                      }
                    : () {},
                child: ListTile(
                  leading: Icon(
                    Icons.reviews,
                    color: isYourReview() ? Colors.black : const Color.fromARGB(255, 120, 120, 120),
                  ),
                  title: Text(
                    "리뷰 수정 하기",
                    style: TextStyle(
                      color: isYourReview() ? Colors.black : const Color.fromARGB(255, 120, 120, 120),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onLongPress: pressTrailingIcon,
          child: Container(
            width: double.infinity,
            margin: widget.margin,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(180, 240, 240, 240),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "리뷰어 별점: ",
                      style: detailTextStyle,
                    ),
                    DisplayAverageScoreWidget(averageScore: widget.review.starRateScore),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "작성일: ${parseStringDate(widget.review.createdAt)}",
                      style: detailTextStyle,
                    ),
                    Text(
                      "작성자: ${widget.review.nickName}",
                      style: detailTextStyle,
                    )
                  ],
                ),
                const SizedBox(height: 3),
                isTapped
                    ? const SizedBox.shrink()
                    : Text(
                        widget.review.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                const SizedBox(height: 5),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isTapped = !isTapped;
                      });
                    },
                    child: Container(
                      width: 85,
                      height: 30,
                      decoration: quickButtonDecoration,
                      child: Center(
                        child: Text(
                          isTapped ? "상세 보기 닫기" : "상세 보기 펼침",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 70, 70, 70),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isTapped ? 5.0 : 0),
                isTapped
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.review.content,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Column(
                            children: [
                              Builder(
                                builder: (BuildContext context) {
                                  List<FileSource> reviewImageFiles = widget.review.imageUrls
                                      .map(
                                        (url) => FileSource(file: File(url), source: MediaSource.server),
                                      )
                                      .toList();
                                  return Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "이미지 파일 개수: ${reviewImageFiles.length}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 120,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: reviewImageFiles.length,
                                          itemBuilder: (context, index) {
                                            FileSource reviewImageFile = reviewImageFiles[index];
                                            return Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () => ExpandImageDialog.show(
                                                    context,
                                                    imageFile: reviewImageFile,
                                                    imageFiles: reviewImageFiles,
                                                  ),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(5),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      child: Image.network(
                                                        reviewImageFile.file.path,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () => ExpandImageDialog.show(
                                                    context,
                                                    imageFile: reviewImageFile,
                                                    imageFiles: reviewImageFiles,
                                                  ),
                                                  icon: const Icon(Icons.search, size: 30, color: Colors.white),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 5),
                              Builder(
                                builder: (BuildContext context) {
                                  List<FileSource> reviewVideoFiles = widget.review.videoUrls
                                      .map(
                                        (url) => FileSource(file: File(url), source: MediaSource.server),
                                      )
                                      .toList();
                                  return Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "비디오 파일 개수: ${reviewVideoFiles.length}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 100,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: reviewVideoFiles.length,
                                          itemBuilder: (context, index) {
                                            FileSource reviewVideoFile = reviewVideoFiles[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                  "/review_video_player",
                                                  arguments: FileSource(file: File(reviewVideoFile.file.path), source: MediaSource.server),
                                                );
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.black,
                                                ),
                                                child: const Icon(
                                                  Icons.play_circle_fill,
                                                  color: Colors.white70,
                                                  size: 50,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: IconButton(
            onPressed: pressTrailingIcon,
            icon: const Icon(
              Icons.more_vert,
              size: 17,
            ),
          ),
        ),
      ],
    );
  }
}
