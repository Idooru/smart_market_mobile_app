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
  Future<List<MediaFile>> uploadReviewImages(List<File> files) async {
    String? accessToken = _db.getString("access-token");
    DataState<List<MediaFile>> dataState = await _mediaRepository.uploadReviewImages(files, accessToken!);
    if (dataState.exception != null) branchNetworkError(dataState);
    return dataState.data!;
  }

  @override
  Future<void> deleteReviewImages(List<MediaFile> reviewImages) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _mediaRepository.deleteReviewImages(reviewImages, accessToken!);
    if (dataState.exception != null) branchNetworkError(dataState);
  }

  @override
  Future<List<MediaFile>> uploadReviewVideos(List<File> files) async {
    String? accessToken = _db.getString("access-token");
    DataState<List<MediaFile>> dataState = await _mediaRepository.uploadReviewVideos(files, accessToken!);
    if (dataState.exception != null) branchNetworkError(dataState);
    return dataState.data!;
  }

  @override
  Future<void> deleteReviewVideos(List<MediaFile> reviewVideos) async {
    String? accessToken = _db.getString("access-token");
    DataState<void> dataState = await _mediaRepository.deleteReviewVideos(reviewVideos, accessToken!);
    if (dataState.exception != null) branchNetworkError(dataState);
  }
}
