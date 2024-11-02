
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/utils/images.dart';
import 'package:flutter/material.dart';

class PersonalData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: screenSize.height - 230,
        width: screenSize.width / 1.2,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: pLightGray,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProfileTile('NOME', 'Nome Sobrenome'),
                    _buildProfileTile('DATA DE NASCIMENTO', 'DD/MM/YYYY'),
                    _buildProfileTile('EMAIL', 'nome@email.com'),
                    _buildStatisticsTile(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30), // Espaço entre o conteúdo e o botão
            _buildEditButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      color: pWhite,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: pDarkRed,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: pBlack),
        ),
      ),
    );
  }

  Widget _buildStatisticsTile() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      color: pWhite,
      child: ListTile(
        title: Text(
          'ESTATÍSTICAS DE TREINO',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: pDarkRed,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatText('Maior Sequência de treinos: 7', pLightRed),
            _buildStatText('Treinos concluídos: 18', pLightRed),
            _buildStatText('Quantidade de fichas: 5', pLightRed),
            _buildStatText('Número de amigos: 4', pLightRed),
          ],
        ),
      ),
    );
  }

  Widget _buildStatText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, color: color),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/home');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: pRed,
          foregroundColor: pLightGray,
          minimumSize: const Size(60, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 8,
        ),
        child: Icon(Icons.edit, size: 30),
      ),
    );
  }
}
