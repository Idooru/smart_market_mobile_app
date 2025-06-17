import 'dart:io';

import 'package:smart_market/model/media/domain/entities/media_file.entity.dart';

import '../../../../core/common/data_state.dart';

abstract interface class MediaRepository {
  Future<DataState<List<MediaFile>>> uploadReviewImages(List<File> files, String accessToken);
  Future<DataState<void>> deleteReviewImages(List<MediaFile> reviewImages, String accessToken);
  Future<DataState<List<MediaFile>>> uploadReviewVideos(List<File> files, String accessToken);
  Future<DataState<void>> deleteReviewVideos(List<MediaFile> reviewVideos, String accessToken);
}
