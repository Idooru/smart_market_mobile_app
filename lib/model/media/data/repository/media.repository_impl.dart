import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/model/media/domain/entities/media_file.entity.dart';

import '../../../../core/utils/dio_initializer.dart';
import '../../../../core/utils/get_it_initializer.dart';
import '../../domain/repository/media.repository.dart';

class MediaRepositoryImpl implements MediaRepository {
  final DioInitializer _authorizationHttpClient = locator<DioInitializer>(instanceName: "authorization");
  final String _baseUrl = RequestUrl.getUrl("/client/media");

  Future<FormData> _createFormData(List<File> files, String label) async {
    final formData = FormData();

    for (var file in files) {
      String fileName = file.path.split('/').last;

      final mimeType = lookupMimeType(file.path);
      final split = mimeType?.split('/') ?? ['application', 'octet-stream'];

      formData.files.add(
        MapEntry(
          label,
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType(split[0], split[1]),
          ),
        ),
      );
    }

    return formData;
  }

  @override
  Future<DataState<List<MediaFile>>> uploadReviewImages(List<File> files, String accessToken) async {
    String url = "$_baseUrl/review/image";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);
    FormData formData = await _createFormData(files, "review_image");

    try {
      Response response = await dio.post(url, data: formData);
      List<MediaFile> mediaFiles = List<Map<String, dynamic>>.from(response.data["result"]).map((item) => MediaFile.fromJson(item)).toList();
      return DataSuccess(data: mediaFiles);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> deleteReviewImages(List<MediaFile> reviewImages, String accessToken) async {
    String url = "$_baseUrl/review/image";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.delete(
        url,
        data: reviewImages.map((e) => e.toJson()).toList(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<List<MediaFile>>> uploadReviewVideos(List<File> files, String accessToken) async {
    String url = "$_baseUrl/review/video";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);
    FormData formData = await _createFormData(files, "review_video");

    try {
      Response response = await dio.post(url, data: formData);
      List<MediaFile> mediaFiles = List<Map<String, dynamic>>.from(response.data["result"]).map((item) => MediaFile.fromJson(item)).toList();
      return DataSuccess(data: mediaFiles);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> deleteReviewVideos(List<MediaFile> reviewVideos, String accessToken) async {
    String url = "$_baseUrl/review/video";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      await dio.delete(
        url,
        data: reviewVideos.map((e) => e.toJson()).toList(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
