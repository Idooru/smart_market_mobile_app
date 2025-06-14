import 'dart:io';

import 'package:smart_market/model/media/domain/entities/media_file.entity.dart';

abstract interface class MediaService {
  Future<List<MediaFile>> fetchReviewImages();
  Future<void> uploadReviewImages(List<File> files);
}
