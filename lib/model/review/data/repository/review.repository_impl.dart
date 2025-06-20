import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/core/utils/dio_initializer.dart';
import 'package:smart_market/model/review/domain/entity/create_review.entity.dart';
import 'package:smart_market/model/review/domain/repository/review.repository.dart';

import '../../../../core/utils/get_it_initializer.dart';
import '../../domain/entity/review.entity.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final DioInitializer _authorizationHttpClient = locator<DioInitializer>(instanceName: "authorization");
  final String _baseUrl = RequestUrl.getUrl("/client/review");

  Map<String, String> getFileInfo(File file) {
    String fileName = file.path.split('/').last;
    String? mimeType = lookupMimeType(file.path);
    var [type, subType] = mimeType?.split('/') ?? ['application', 'octet-stream'];

    return {"fileName": fileName, "type": type, "subType": subType};
  }

  Future<FormData> _createFormData(ReviewForm args) async {
    FormData formData = FormData();

    formData.fields.add(MapEntry("content", args.content));
    formData.fields.add(MapEntry("starRateScore", args.starRateScore.toString()));

    Future<void> appendMediaForm(String label, List<File> files) async {
      for (File file in files) {
        Map<String, dynamic> fileInfo = getFileInfo(file);
        formData.files.add(MapEntry(
          label,
          await MultipartFile.fromFile(
            file.path,
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
}
