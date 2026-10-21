import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  Dio dio;
  ApiClient() : dio = Dio(BaseOptions(baseUrl:ApiConstants.baseUrl)){
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
      filter: (option, args) {
        // Filter out sensitive information from logs
        if (option.path.contains('Authorization')) {
          return false; // Exclude Authorization header from logs
        }
        return !args.isResponse|| !args.hasUint8ListData; // Include other logs
      },

    ));
  }

  
}