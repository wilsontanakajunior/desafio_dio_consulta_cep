import 'package:desafio_dio_consultacep/model/back4app_cep_model.dart';
import 'package:desafio_dio_consultacep/model/via_cep_mode.dart';
import 'package:desafio_dio_consultacep/repositories/back4app/back4app_cep_repository.dart';
import 'package:desafio_dio_consultacep/repositories/via_cep/via_cep_repository.dart';
import 'package:desafio_dio_consultacep/shared/widgets/card_cep_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _cepTextEditingController =
      TextEditingController(text: '');
  final _viaCepRepository = ViaCepRepository();
  var _viaCepModel = ViaCepModel();

  final _back4AppCepRepository = Back4AppCepRepository();
  Bakc4AppCepsModel _bakc4AppCepsModel = Bakc4AppCepsModel([]);
  bool _carregandoDados = false;
  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    setState(() {
      _carregandoDados = !_carregandoDados;
    });
    try {
      _bakc4AppCepsModel = await _back4AppCepRepository.consultarCepBack4app();
    } catch (e) {
      _showMessage(
          'Erro ao buscar os ceps cadastrados no back4app', Colors.red);
    }
    setState(() {
      _carregandoDados = !_carregandoDados;
    });
  }

  void _showMessage(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 20),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cadastro de CEPS',
          ),
        ),
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              _cepTextEditingController.text = '';
              showDialog(
                context: context,
                builder: (BuildContext bc) {
                  return AlertDialog(
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Digite o CEP que deseja inserir ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextField(
                            textAlign: TextAlign.start,
                            controller: _cepTextEditingController,
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            showCursor: true,
                            cursorOpacityAnimates: true,
                            cursorWidth: 3,
                            canRequestFocus: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: const InputDecoration(
                              suffixText: 'Digite o cep',
                              labelText: 'Digite o cep',
                            ),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(bc);
                        },
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          var cep = _cepTextEditingController.text
                              .replaceAll(RegExp(r'[^0-9]'), '');
                          if (cep.length == 8) {
                            Navigator.pop(bc);
                            try {
                              _viaCepModel =
                                  await _viaCepRepository.consultarCep(cep);
                              if (_viaCepModel.erro == true) {
                                _showMessage("Cep não encontrado", Colors.red);
                              } else {
                                var resultCepList = _bakc4AppCepsModel.ceps
                                    .where((cepM) =>
                                        cepM.cep!.replaceAll(
                                            RegExp(r'[^0-9]'), '') ==
                                        cep)
                                    .toList();

                                if (resultCepList.isNotEmpty) {
                                  _showMessage(
                                      "Cep já está cadastrado", Colors.red);
                                } else {
                                  var cepTemp = Ceps.criar(
                                    cep: _viaCepModel.cep,
                                    logradouro: _viaCepModel.logradouro,
                                    complemento: _viaCepModel.complemento,
                                    bairro: _viaCepModel.bairro,
                                    localidade: _viaCepModel.localidade,
                                    uf: _viaCepModel.uf,
                                    ibge: _viaCepModel.ibge,
                                    gia: _viaCepModel.gia,
                                    ddd: _viaCepModel.ddd,
                                    siafi: _viaCepModel.siafi,
                                  );
                                  await _back4AppCepRepository
                                      .criarCep(cepTemp);
                                  _showMessage("CEP adicionado com sucesso",
                                      Colors.green);
                                  carregarDados();
                                }
                              }
                            } on DioException {
                              _showMessage(
                                "Erro desconhecido ao consultar o CEP",
                                Colors.red,
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Adicionar',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(
              Icons.add_outlined,
              color: Colors.white,
              size: 45,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: _carregandoDados
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _bakc4AppCepsModel.ceps.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.data_array_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                          Text(
                            'Sem CEPs cadastrados',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: Text(
                            textAlign: TextAlign.center,
                            'Listagem dos CEPS cadastrados',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 6 / 100,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _bakc4AppCepsModel.ceps.length,
                            itemBuilder: (context, index) {
                              var cep = _bakc4AppCepsModel.ceps[index];
                              return Dismissible(
                                onDismissed: (__) async {
                                  await _back4AppCepRepository.deletarCep(cep);
                                  _showMessage(
                                    'Cep deletado com sucesso',
                                    Colors.green,
                                  );
                                  carregarDados();
                                },
                                confirmDismiss: (direction) {
                                  return showDialog(
                                    context: context,
                                    builder: (BuildContext bc) {
                                      return AlertDialog(
                                        content: Container(
                                          padding: const EdgeInsets.all(10),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text(
                                                'Deseja deletar o Cep? ',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                cep.cep.toString(),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.of(bc).pop(false);
                                            },
                                            child: const Text(
                                              'Cancelar',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.of(bc).pop(true);
                                            },
                                            child: const Text(
                                              'Excluir',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                background: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  color: Colors
                                      .red, // Cor de fundo enquanto arrasta
                                  alignment: Alignment.centerRight,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Deletar Cep',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                                key: Key(cep.objectId.toString()),
                                child: CardCepItem(
                                  bakc4AppCepsModel: cep,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
