import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';

class RequestUrl {
  static final String _baseUrl = dotenv.get('API_URL');

  static String getUrl(String domain) {
    return _baseUrl + domain;
  }
}

abstract class DioInitializer {
  final _dio = Dio();

  Future<Dio> getClient({ClientArgs? args});
}

class ClientArgs {
  final String? email;
  final String? password;
  final String? accessToken;

  const ClientArgs({
    this.email,
    this.password,
    this.accessToken,
  });
}

class CommonHttpClient extends DioInitializer {
  @override
  Future<Dio> getClient({ClientArgs? args}) async {
    return super._dio;
  }
}

class AuthenticationHttpClient extends DioInitializer {
  @override
  Future<Dio> getClient({ClientArgs? args}) async {
    return _manualDio(args!.email!, args.password!);
  }

  Future<Dio> _manualDio(String email, String password) async {
    Dio dio = super._dio;

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers["Authorization"] = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';
        return handler.next(options);
      },
    ));

    return dio;
  }
}

class AuthorizationHttpClient extends DioInitializer {
  final SharedPreferences _db = locator<SharedPreferences>();
  final String _baseUrl = RequestUrl.getUrl("/user");

  @override
  Future<Dio> getClient({ClientArgs? args}) async {
    return _manualDio(args!.accessToken!);
  }

  Dio _generateRefreshDio() {
    Dio refreshDio = super._dio;
    String? newAccessToken = _db.getString("access-token");

    refreshDio.interceptors.clear();
    refreshDio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          // refresh-token 만료 후 로그아웃 로직
          if (error.response?.data['error'] == "TokenExpiredError") {
            await _db.remove("access-token");
          }
          return handler.next(error);
        },
      ),
    );

    // 토큰 갱신 API 요청 시 AccessToken(만료), RefreshToken 포함
    refreshDio.options.headers['access-token'] = newAccessToken!;

    return refreshDio;
  }

  Future<String> _requestRefreshToken(Dio refreshDio) async {
    String url = "$_baseUrl/refresh-token";
    Response response = await refreshDio.patch(url);
    return response.headers['access-token']![0];
  }

  Future<Dio> _manualDio(String accessToken) async {
    Dio dio = super._dio;

    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers["access-token"] = accessToken;
        return handler.next(options);
      },
      onError: (error, handler) async {
        // access-token 만료 후 재발급 로직
        if (error.response!.data['error'] == "TokenExpiredError") {
          Dio refreshDio = _generateRefreshDio();
          String newAccessToken = await _requestRefreshToken(refreshDio);

          await _db.setString("access-token", newAccessToken);
          error.requestOptions.headers['access-token'] = newAccessToken;

          Response response = await dio.request(
            error.requestOptions.path,
            options: Options(method: error.requestOptions.method, headers: error.requestOptions.headers),
            data: error.requestOptions.data,
            queryParameters: error.requestOptions.queryParameters,
          );

          return handler.resolve(response);
        }
        return handler.next(error);
      },
    ));

    return dio;
  }
}

void initDioLocator(GetIt locator) {
  locator.registerLazySingleton<DioInitializer>(() => CommonHttpClient(), instanceName: "common");
  locator.registerLazySingleton<DioInitializer>(() => AuthenticationHttpClient(), instanceName: "authentication");
  locator.registerLazySingleton<DioInitializer>(() => AuthorizationHttpClient(), instanceName: "authorization");
}
