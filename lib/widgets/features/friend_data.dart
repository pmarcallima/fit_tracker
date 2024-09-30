


import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';


class FriendData extends StatelessWidget {
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

          const SizedBox(height: 15),

        ],
      ),
    );
  }
}
