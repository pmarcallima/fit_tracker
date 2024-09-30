
import 'package:fit_tracker/main.dart';
import 'package:fit_tracker/pages/tabs/home.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';

class ButtonColumnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width / 3,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ajusta o tamanho dos botões
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/workouts');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pRed, // Cor de fundo do botão
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Borda arredondada
              ),
              elevation: 5, // Sombra para destaque
            ),
            child: Text(
              'Fazer login',
              style: TextStyle(
                fontSize: 18, // Tamanho da fonte
                fontWeight: FontWeight.bold, // Negrito
                color: pLightGray, // Cor do texto
              ),
            ),
          ),
          SizedBox(height: 10.0), // Espaço entre os botões
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: pLightBlack, // Cor de fundo do botão
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Borda arredondada
              ),
              elevation: 5, // Sombra para destaque
            ),
            child: Text(
              'Criar uma conta',
              style: TextStyle(
                fontSize: 18, // Tamanho da fonte
                fontWeight: FontWeight.bold, // Negrito
                color: pLightGray, // Cor do texto
              ),
            ),
          ),
        ],
      ),
    );
  }
}
