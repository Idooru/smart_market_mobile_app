import 'package:flutter/material.dart';
import 'package:smart_market/model/review/presentation/dialog/sort_review.dialog.dart';

import '../../../../core/errors/connection_error.dart';
import '../../../../core/errors/dio_fail.error.dart';
import '../../../../core/themes/theme_data.dart';
import '../../../../core/utils/check_jwt_duration.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../../../core/widgets/common/custom_scrollbar.widget.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/loading_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../common/const/request_all_review.args.dart';
import '../../domain/entity/all_review.entity.dart';
import '../../domain/service/review.service.dart';
import '../widgets/item/all_review_item.widget.dart';

class AllReviewsPage extends StatefulWidget {
  const AllReviewsPage({super.key});

  @override
  State<AllReviewsPage> createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage> {
  final ReviewService _reviewService = locator<ReviewService>();
  final ScrollController controller = ScrollController();
  late Future<List<ResponseAllReview>> _getAllReviewsFuture;

  bool _hasFilterButton = false;

  @override
  void initState() {
    super.initState();
    _getAllReviewsFuture = initAllReviewsPage();
  }

  Future<List<ResponseAllReview>> initAllReviewsPage() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await checkJwtDuration();

    return _reviewService.fetchReviews(RequestAllReviewsArgs.args);
  }

  void updateIsShow(bool value) {
    if (_hasFilterButton == value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _hasFilterButton = value;
      });
    });
  }

  void updateReviews(RequestAllReviews args) {
    setState(() {
      _getAllReviewsFuture = _reviewService.fetchReviews(args);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ResponseAllReview>>(
        future: _getAllReviewsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<ResponseAllReview>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingHandlerWidget(title: "리뷰 리스트 불러오기..");
          } else if (snapshot.hasError) {
            updateIsShow(false);
            final error = snapshot.error;
            if (error is ConnectionError) {
              return NetworkErrorHandlerWidget(
                reconnectCallback: () {
                  updateReviews(RequestAllReviewsArgs.args);
                },
                hasReturn: true,
              );
            } else if (error is DioFailError) {
              return const InternalServerErrorHandlerWidget(hasReturn: true);
            } else {
              return Center(child: Text("$error"));
            }
          } else {
            List<ResponseAllReview> reviews = snapshot.data!;
            updateIsShow(reviews.isNotEmpty);
            return Scaffold(
              appBar: AppBar(
                title: const Text("My reviews"),
                centerTitle: false,
                flexibleSpace: appBarColor,
                actions: [
                  _hasFilterButton
                      ? IconButton(
                          onPressed: () => SortReviewDialog.show(context, updateCallback: updateReviews),
                          icon: const Icon(Icons.tune, color: Colors.black),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              body: CustomScrollbarWidget(
                scrollController: controller,
                childWidget: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: controller.hasClients ? 13 : 10,
                  ),
                  child: Builder(
                    builder: (context) {
                      if (reviews.isNotEmpty) {
                        return ListView.builder(
                          controller: controller,
                          itemCount: reviews.length,
                          itemBuilder: (context, index) => AllReviewItemWidget(
                            responseAllReview: reviews[index],
                            margin: index != reviews.length - 1 ? const EdgeInsets.only(bottom: 10) : EdgeInsets.zero,
                            updateCallback: updateReviews,
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "작성된 리뷰가 없습니다.",
                            style: TextStyle(
                              color: Color.fromARGB(255, 90, 90, 90),
                              fontSize: 15,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
