import 'package:get_it/get_it.dart';

import '../../data/repository/media.repository_impl.dart';
import '../../data/service/media.service_impl.dart';
import '../../domain/repository/media.repository.dart';
import '../../domain/service/media.service.dart';

void initMediaLocator(GetIt locator) {
  locator.registerLazySingleton<MediaService>(() => MediaServiceImpl());
  locator.registerLazySingleton<MediaRepository>(() => MediaRepositoryImpl());
}
