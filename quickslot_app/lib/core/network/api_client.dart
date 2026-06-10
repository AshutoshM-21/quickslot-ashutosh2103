import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quickslot_app/core/constants/app_constants.dart';

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? Dio(_defaultOptions) {
    _setupInterceptors();
  }

  final Dio _dio;

  Dio get dio => _dio;

  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: AppConstants.connectTimeout,
    receiveTimeout: AppConstants.receiveTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  void _setupInterceptors() {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
    }
  }
}
