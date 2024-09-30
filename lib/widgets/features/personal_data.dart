
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';


class PersonalData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width / 1.2,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ajusta o tamanho da coluna
        children: [
          const Card(
            color: pWhite,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('NOME'),
              subtitle: Text('Nome Sobrenome'),
            ),
          ),

          const Card(
            color: pWhite,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('DATA DE NASCIMENTO'),
              subtitle: Text('DD/MM/YYYY'),
            ),
          ),

          const Card(
            color: pWhite,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('EMAIL'),
              subtitle: Text('nome@email.com'),
            ),
          ),

          const Card(
            color: pWhite,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('ESTATÍSTICAS DE TREINO'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('%', style: TextStyle(fontSize: 16)),
                  Text('%', style: TextStyle(fontSize: 16)),
                  Text('%', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),

          // Botão com tamanho ajustado
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: pLightGray2,
                minimumSize: const Size(100, 100), // Define o tamanho mínimo do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Define o raio das bordas
                ),
                elevation: 8, // Adiciona sombra ao botão, aumentando o valor para mais sombra
                shadowColor: Colors.black, // Define a cor da sombra (opcional)
              ),
              child: Image.asset(
                EDIT,
                width: 30, // Ajuste o tamanho da imagem, se necessário
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
