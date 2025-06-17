import 'dart:io';

import 'package:smart_market/model/media/domain/entities/media_file.entity.dart';

abstract interface class MediaService {
  Future<List<MediaFile>> uploadReviewImages(List<File> files);
  Future<void> deleteReviewImages(List<MediaFile> reviewImages);
  Future<List<MediaFile>> uploadReviewVideos(List<File> files);
  Future<void> deleteReviewVideos(List<MediaFile> reviewVideos);
}
