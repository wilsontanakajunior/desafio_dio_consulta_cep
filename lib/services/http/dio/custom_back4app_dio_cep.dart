import 'package:desafio_dio_consultacep/repositories/back4app/back4app_interceptor_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomBack4AppDioCep {
  final _dio = Dio();

  Dio get dio => _dio;

  CustomBack4AppDioCep() {
    _dio.options.baseUrl = dotenv.get('BACK4APPBASEURL');
    _dio.options.headers['content-type'] = 'application/json';
    _dio.interceptors.add(Back4AppInterceptorDio());
  }
}
