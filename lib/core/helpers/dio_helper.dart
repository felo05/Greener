import 'package:dio/dio.dart';

import '../constants/kapi.dart';

class DioHelpers {
  static Dio? _dio;

  DioHelpers._();

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: KApi.perenualBaseUrl,
        receiveTimeout: const Duration(
          seconds: 120,
        ),
        sendTimeout: const Duration(
          seconds: 120,
        ),
        connectTimeout: const Duration(
          seconds: 120,
        ),
        headers: {
          "Content-Type": "application/json",
          "key": KApi.perenualApiKey,
        },
      ),
    );
  }

  //Get
  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    queryParameters ??= {};
    queryParameters.addAll({"key": KApi.perenualApiKey});
    final response = await _dio!.get(path, queryParameters: queryParameters);
    return response;
  }

  static Future<Response> postData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final response = _dio!.post(
      path,
      queryParameters: queryParameters,
      data: body,
    );
    return response;
  }

}
