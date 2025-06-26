import '../../domain/entity/all_review.entity.dart';

class RequestAllReviewsArgs {
  static RequestAllReviews _args = const RequestAllReviews(
    align: "DESC",
    column: "createdAt",
  );
  static RequestAllReviews get args => _args;

  static void setArgs(RequestAllReviews args) {
    _args = args;
  }
}
