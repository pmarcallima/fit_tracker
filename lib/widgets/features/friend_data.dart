import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fit_tracker/services/providers/firebase_helper.dart';
import 'package:fit_tracker/services/models/statistics.dart';
import 'package:fit_tracker/services/models/user.dart';
import 'package:fit_tracker/utils/global_context.dart';
import 'package:fit_tracker/widgets/features/friend_data.dart';

class FriendData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final friendId = GlobalContext.friendId!;

    return _buildUserData(friendId, context);
  }

  Widget _buildUserData(String friendId, BuildContext context) {
    final dbHelper = FirebaseService();
    final screenSize = MediaQuery.of(context).size;

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
                future: dbHelper.getUserById(friendId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (userSnapshot.hasError) {
                    return Center(
                        child: Text('Erro ao carregar dados do usuário'));
                  }
                  final user = userSnapshot.data;
                  if (user == null) {
                    return Center(child: Text('Usuário não encontrado.'));
                  }

                  return FutureBuilder<Statistic?>(
                    future: dbHelper.getStatisticsByUserId(friendId),
                    builder: (context, statsSnapshot) {
                      if (statsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (statsSnapshot.hasError) {
                        return Center(
                            child: Text('Erro ao carregar estatísticas'));
                      }
                      final statistics = statsSnapshot.data;
                      if (statistics == null) {
                        return Center(
                            child: Text('Estatísticas não disponíveis.'));
                      }

                      DateTime? birthDateMilliseconds = user.birthDate;

                      return Column(
                        children: [
                          _buildProfileTile(
                              'NOME', '${user.firstName} ${user.lastName}'),
                          _buildProfileTile(
                            'DATA DE NASCIMENTO',
                            '${DateTime.fromMillisecondsSinceEpoch((birthDateMilliseconds ?? 0) as int).toLocal()}'
                                .split(' ')[0],
                          ),
                          _buildStatisticsTile(statistics),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
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
          style: const TextStyle(color: pBlack),
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
            _buildStatText(
                'Maior Sequência de Treinos: ${statistics.biggestStreak}',
                pLightRed),
            _buildStatText(
                'Treinos Concluídos: ${statistics.totalWorkouts}', pLightRed),
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
