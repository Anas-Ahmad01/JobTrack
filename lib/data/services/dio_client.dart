import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }
      )
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      )
    );
  }

  Dio get dio => _dio;
}