import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/media/domain/entities/file_source.entity.dart';
import 'package:smart_market/model/review/domain/entity/create_review.entity.dart';
import 'package:smart_market/model/review/domain/entity/modify_review.entity.dart';
import 'package:smart_market/model/review/domain/repository/review.repository.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../domain/entity/all_review.entity.dart';
import '../../domain/entity/detail_review.entity.dart';
import '../../domain/entity/review_form.entity.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final DioInitializer _authorizationHttpClient = locator<DioInitializer>(instanceName: "authorization");
  final String _baseUrl = RequestUrl.getUrl("/client/review");

  Map<String, String> getFileInfo(File file) {
    String fileName = file.path.split('/').last;
    String? mimeType = lookupMimeType(file.path);
    var [type, subType] = mimeType?.split('/') ?? ['application', 'octet-stream'];

    return {"fileName": fileName, "type": type, "subType": subType};
  }

  Future<File> downloadFile(String url, String filename) async {
    ClientArgs clientArgs = const ClientArgs();
    Dio dio = locator<DioInitializer>(instanceName: "common").getClient(args: clientArgs);
    final dir = await getTemporaryDirectory();
    String savePath = '${dir.path}/$filename';

    await dio.download(
      url,
      savePath,
      options: Options(responseType: ResponseType.bytes),
    );

    return File(savePath);
  }

  Future<FormData> _createFormData(ReviewForm args) async {
    FormData formData = FormData();

    formData.fields.add(MapEntry("content", args.content));
    formData.fields.add(MapEntry("starRateScore", args.starRateScore.toString()));

    Future<void> appendMediaForm(String label, List<FileSource> files) async {
      for (FileSource fileSource in files) {
        Map<String, dynamic> fileInfo = getFileInfo(fileSource.file);
        File uploadFile = fileSource.source == MediaSource.file ? fileSource.file : await downloadFile(fileSource.file.path, fileInfo["fileName"]);

        formData.files.add(MapEntry(
          label,
          await MultipartFile.fromFile(
            uploadFile.path,
            filename: fileInfo["fileName"],
            contentType: MediaType(fileInfo["type"], fileInfo["subType"]),
          ),
        ));
      }
    }

    await appendMediaForm("review_image", args.reviewImages);
    await appendMediaForm("review_video", args.reviewVideos);

    return formData;
  }

  @override
  Future<DataState<List<ResponseAllReview>>> fetchReviews(String accessToken, RequestAllReviews args) async {
    String url = "$_baseUrl/all?align=${args.align}&column=${args.column}";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      Response response = await dio.get(url);

      List<ResponseAllReview> reviews = List<Map<String, dynamic>>.from(response.data["result"]).map((e) => ResponseAllReview.fromJson(e)).toList();
      return DataSuccess(data: reviews);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<ResponseDetailReview>> fetchDetailReview(String accessToken, String reviewId) async {
    String url = "$_baseUrl/$reviewId";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);

    try {
      Response response = await dio.get(url);

      ResponseDetailReview review = ResponseDetailReview.fromJson(response.data["result"]);
      return DataSuccess(data: review);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> createReview(String accessToken, RequestCreateReview args) async {
    String url = "$_baseUrl/product/${args.productId}";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);
    FormData formData = await _createFormData(args);

    try {
      await dio.post(url, data: formData);

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }

  @override
  Future<DataState<void>> modifyReview(String accessToken, RequestModifyReview args) async {
    String url = "$_baseUrl/${args.reviewId}/product/${args.productId}";
    ClientArgs clientArgs = ClientArgs(accessToken: accessToken);
    Dio dio = _authorizationHttpClient.getClient(args: clientArgs);
    FormData formData = await _createFormData(args);

    try {
      await dio.put(url, data: formData);

      return const DataSuccess(data: null);
    } on DioException catch (err) {
      return DataFail(exception: err);
    }
  }
}
