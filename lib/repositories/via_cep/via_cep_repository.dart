import 'package:desafio_dio_consultacep/model/via_cep_mode.dart';
import 'package:desafio_dio_consultacep/services/http/dio/custom_dio_via_cep.dart';

class ViaCepRepository {
  final _customDio = CustomDioViaCep().dio;

  Future<ViaCepModel> consultarCep(String cep) async {
    var url = '/$cep/json/';
    var result = await _customDio.get(url);
    return ViaCepModel.fromJson(result.data);
  }
}
