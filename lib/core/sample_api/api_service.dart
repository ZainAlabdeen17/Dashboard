import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_const.dart';
import 'api_method.dart';

class SimpleApiService {
  static SimpleApiService? _instance;
  late dio.Dio _dio;

  SimpleApiService._() {
    _dio = dio.Dio(dio.BaseOptions(
      baseUrl: ApiConst.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization' : 'Bearer 3|2EP26oxp6AKfCJgGAHgoptsBoZsg0MsrGt5xzYFp4b3091bc'
      },
    ));

    // إضافة interceptors للطباعة و curl logging
    if (!kReleaseMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));

      _dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    }
  }

  static SimpleApiService get instance {
    _instance ??= SimpleApiService._();
    return _instance!;
  }


  Future<Either<String, dynamic>> makeRequest({
    required ApiMethod method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      dio.Response response;

      final options = dio.Options();

      switch (method) {
        case ApiMethod.get:
          response = await _dio.get(
            endpoint,
            queryParameters: queryParams,
            options: options,
          );
          break;
        case ApiMethod.post:
          response = await _dio.post(
            endpoint,
            data: body,
            queryParameters: queryParams,
            options: options,
          );
          break;
        case ApiMethod.put:
          response = await _dio.put(
            endpoint,
            data: body,
            queryParameters: queryParams,
            options: options,
          );
          break;
        case ApiMethod.delete:
          response = await _dio.delete(
            endpoint,
            data: body,
            queryParameters: queryParams,
            options: options,
          );
          break;
        case ApiMethod.patch:
          response = await _dio.patch(
            endpoint,
            data: body,
            queryParameters: queryParams,
            options: options,
          );
          break;
      }

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return Right(response.data);
      } else {
        return Left(response.data['error_message']);
      }
    } catch (e) {
      if (e is dio.DioException) {
        return Left('Error: ${e.message ?? 'Unknown error'}');
      }
      return Left('Unexpected error: $e');
    }
  }
}

