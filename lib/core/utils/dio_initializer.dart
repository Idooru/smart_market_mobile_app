import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioInitializer {
  final dio = Dio();
  final baseUrl = dotenv.get('API_URL');
}
