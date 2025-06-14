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

      // MIME 타입 추론 (예: image/jpeg)
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
  Future<DataState<List<String>>> uploadReviewImages(List<File> files, String accessToken) async {
    String url = "$_baseUrl/review/image";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);
    FormData formData = await _createFormData(files, "review_image");

    try {
      Response response = await dio.post(url, data: formData);
      List<String> reviewImageIds = List<String>.from(response.headers["review_image_url_header"]!).map((item) => item.replaceAll(r'\', '').replaceAll('"', '')).toList();

      return DataSuccess(data: reviewImageIds);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<List<MediaFile>>> fetchReviewImages(List<String> reviewImageIds, String accessToken) async {
    String url = "$_baseUrl/review/image";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {"review_image_url_header": reviewImageIds},
        ),
      );

      List<MediaFile> reviewImages = List<Map<String, dynamic>>.from(response.data["result"]).map((item) => MediaFile.fromJson(item)).toList();

      return DataSuccess(data: reviewImages);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
