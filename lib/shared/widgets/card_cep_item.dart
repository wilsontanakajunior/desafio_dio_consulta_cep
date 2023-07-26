import 'package:desafio_dio_consultacep/model/back4app_cep_model.dart';
import 'package:flutter/material.dart';

class CardCepItem extends StatelessWidget {
  final Ceps bakc4AppCepsModel;
  const CardCepItem({
    super.key,
    required this.bakc4AppCepsModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Sombra do card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side:
            BorderSide(color: Colors.grey.shade300, width: 1), // Borda do card
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(
              Icons.apartment_outlined,
              color: Colors.green,
              size: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Cidade: ${bakc4AppCepsModel.localidade}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'Estado: ${bakc4AppCepsModel.uf}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Cep: ${bakc4AppCepsModel.cep}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'DDD: ${bakc4AppCepsModel.ddd}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
