import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/utils/throw_network_error.dart';
import 'package:smart_market/model/media/domain/entities/media_file.entity.dart';
import 'package:smart_market/model/media/domain/repository/media.repository.dart';
import 'package:smart_market/model/media/domain/service/media.service.dart';

import '../../../../core/common/data_state.dart';
import '../../../../core/utils/get_it_initializer.dart';

class MediaServiceImpl implements MediaService {
  final SharedPreferences _db = locator<SharedPreferences>();
  final MediaRepository _mediaRepository = locator<MediaRepository>();

  @override
  Future<void> uploadReviewImages(List<File> files) async {
    String? accessToken = _db.getString("access-token");

    DataState<List<String>> dataState = await _mediaRepository.uploadReviewImages(files, accessToken!);
    if (dataState.exception != null) branchNetworkError(dataState);

    List<String> newIds = dataState.data!;
    List<String> existingIds = _db.getStringList("uploaded-review-image-ids") ?? [];
    List<String> updatedIds = [...existingIds, ...newIds];
    await _db.setStringList("uploaded-review-image-ids", updatedIds);
  }

  @override
  Future<List<MediaFile>> fetchReviewImages() async {
    String? accessToken = _db.getString("access-token");
    List<String> reviewImageIds = _db.getStringList("uploaded-review-image-ids")!;

    DataState<List<MediaFile>> dataState = await _mediaRepository.fetchReviewImages(reviewImageIds, accessToken!);
    if (dataState.exception != null) branchNetworkError(dataState);
    return dataState.data!;
  }
}
