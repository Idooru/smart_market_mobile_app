import 'package:get_it/get_it.dart';
import 'package:smart_market/model/review/data/service/review.service_impl.dart';
import 'package:smart_market/model/review/domain/repository/review.repository.dart';
import 'package:smart_market/model/review/domain/service/review.service.dart';

import '../../data/repository/review.repository_impl.dart';

void initReviewLocator(GetIt locator) {
  locator.registerLazySingleton<ReviewService>(() => ReviewServiceImpl());
  locator.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl());
}
