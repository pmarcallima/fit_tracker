
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:fit_tracker/services/providers/database_helper.dart'; // Importar seu DatabaseHelper
import 'package:fit_tracker/services/models/statistics.dart'; // Importar seu modelo Statistic
import 'package:fit_tracker/services/models/user.dart'; // Importar seu modelo User
import 'package:fit_tracker/utils/global_context.dart'; // Importar o Provider para acessar o GlobalContext

class PersonalData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = GlobalContext.userId!;
    print("$userId");

    return _buildUserData(userId, context);
  }

  Widget _buildUserData(int userId, BuildContext context) {
  final dbHelper = DatabaseHelper();
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
              child: FutureBuilder<User?>(
                future: dbHelper.getUserById(userId), // Chamar o método para obter o usuário
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (userSnapshot.hasError) {
                    return Center(child: Text('Erro ao carregar dados do usuário'));
                  }

                  final user = userSnapshot.data!;

                  return FutureBuilder<Statistic>(
                    future: dbHelper.getStatisticsByUserId(userId), // Chamar o método para obter as estatísticas
                    builder: (context, statsSnapshot) {
                      if (statsSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (statsSnapshot.hasError) {
                        return Center(child: Text('Erro ao carregar estatísticas'));
                      }

                      final statistics = statsSnapshot.data!;

      int birthDateMilliseconds = user.birthDate ?? 0; // Se for null, assume 0

                      return Column(

                        children: [
                          _buildProfileTile('NOME', '${user.firstName} ${user.lastName}'),
                          _buildProfileTile('DATA DE NASCIMENTO', '${DateTime.fromMillisecondsSinceEpoch(birthDateMilliseconds)}'.split(' ')[0]), // Formatação da data
                          _buildProfileTile('EMAIL', user.email),
                          _buildStatisticsTile(statistics),
                        ],
                      );
                    },
                  );
                },
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

  Widget _buildStatisticsTile(Statistic statistics) {
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
            _buildStatText('Maior Sequência de treinos: ${statistics.biggestStreak}', pLightRed),
            _buildStatText('Treinos concluídos: ${statistics.totalWorkouts}', pLightRed),
            _buildStatText('Quantidade de fichas: ${statistics.userId}', pLightRed), // Corrija se necessário
            _buildStatText('Número de amigos: ${statistics.totalFriends}', pLightRed),
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
