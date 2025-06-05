import 'package:flutter/material.dart';
import 'package:smart_market/core/utils/parse_date.dart';
import 'package:smart_market/model/product/domain/entities/detail_product.entity.dart';
import 'package:smart_market/model/product/presentation/widgets/display_average_score.widget.dart';
import 'package:smart_market/model/product/presentation/widgets/image/review_image_grid.widget.dart';

import '../../pages/review_video_player.page.dart';

class ReviewItemWidget extends StatefulWidget {
  final Review review;
  final EdgeInsets margin;

  const ReviewItemWidget({
    super.key,
    required this.review,
    required this.margin,
  });

  @override
  State<ReviewItemWidget> createState() => _ReviewItemWidgetState();
}

class _ReviewItemWidgetState extends State<ReviewItemWidget> {
  final TextStyle detailTextStyle = const TextStyle(fontSize: 12, color: Color.fromARGB(255, 90, 90, 90));
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            widget.review.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
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
          isTapped
              ? Container()
              : Text(
                  widget.review.content,
                  style: const TextStyle(
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
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
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 230, 230, 230),
                  borderRadius: BorderRadius.circular(30),
                ),
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
          isTapped
              ? Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.review.content,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      widget.review.imageUrls.isEmpty
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.review.imageUrls
                                  .map(
                                    (url) => GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) => Dialog(
                                            child: ReviewImageGridWidget(
                                              url: url,
                                              imageUrls: widget.review.imageUrls,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        width: 60,
                                        height: 60,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            url,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                      widget.review.videoUrls.isEmpty
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.review.videoUrls
                                  .map(
                                    (url) => GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          "/review_video_player",
                                          arguments: ReviewVideoPlayerPageArgs(
                                            url: url,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.black,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: const Icon(
                                            Icons.play_circle_fill,
                                            color: Colors.white70,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
