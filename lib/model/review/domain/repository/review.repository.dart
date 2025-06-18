import 'package:smart_market/model/review/domain/entity/create_review.entity.dart';

import '../../../../core/common/data_state.dart';

abstract interface class ReviewRepository {
  Future<DataState<void>> createReview(String accessToken, RequestCreateReview args);
}
