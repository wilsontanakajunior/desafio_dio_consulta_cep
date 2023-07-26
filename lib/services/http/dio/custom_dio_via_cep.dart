import 'package:desafio_dio_consultacep/repositories/via_cep/via_cep_interceptor_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomDioViaCep {
  final _dio = Dio();

  Dio get dio => _dio;

  CustomDioViaCep() {
    _dio.options.baseUrl = dotenv.get('VIACEPURLBASE');
    _dio.options.headers['content-type'] = 'application/json';
    _dio.interceptors.add(ViaCepInterceptorDio());
  }
}
