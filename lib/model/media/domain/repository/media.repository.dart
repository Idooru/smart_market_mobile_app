import 'dart:io';

import 'package:smart_market/model/media/domain/entities/media_file.entity.dart';

import '../../../../core/common/data_state.dart';

abstract interface class MediaRepository {
  Future<DataState<List<MediaFile>>> fetchReviewImages(List<String> reviewImageIds, String accessToken);
  Future<DataState<List<String>>> uploadReviewImages(List<File> files, String accessToken);
}
