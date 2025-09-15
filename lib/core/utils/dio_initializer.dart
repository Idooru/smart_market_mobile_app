import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

class RequestUrl {
  static final String _baseUrl = dotenv.get('API_URL');

  static String getUrl(String domain) {
    return _baseUrl + domain;
  }
}

abstract class DioInitializer {
  final _dio = Dio();

  Dio getClient({ClientArgs? args});
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
  Dio getClient({ClientArgs? args}) {
    return super._dio;
  }
}

class AuthenticationHttpClient extends DioInitializer {
  @override
  Dio getClient({ClientArgs? args}) {
    return _manualDio(args!.email!, args.password!);
  }

  Dio _manualDio(String email, String password) {
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
  @override
  Dio getClient({ClientArgs? args}) {
    return _manualDio(args!.accessToken!);
  }

  Dio _manualDio(String accessToken) {
    Dio dio = super._dio;

    dio.interceptors.clear();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers["Authorization"] = 'Bearer $accessToken';
        return handler.next(options);
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
