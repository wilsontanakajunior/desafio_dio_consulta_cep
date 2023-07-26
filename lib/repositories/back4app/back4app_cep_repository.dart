import 'package:desafio_dio_consultacep/model/back4app_cep_model.dart';
import 'package:desafio_dio_consultacep/services/http/dio/custom_back4app_dio_cep.dart';

class Back4AppCepRepository {
  final _customDio = CustomBack4AppDioCep().dio;

  Future<Bakc4AppCepsModel> consultarCepBack4app() async {
    var url = '/cep';
    var result = await _customDio.get(url);
    return Bakc4AppCepsModel.fromJson(result.data);
  }

  Future<void> criarCep(Ceps cep) async {
    var url = '/cep';
    await _customDio.post(url, data: cep.toCreateJson());
  }

  Future<void> deletarCep(Ceps cep) async {
    var url = '/cep/${cep.objectId}';
    await _customDio.delete(url);
  }
}
