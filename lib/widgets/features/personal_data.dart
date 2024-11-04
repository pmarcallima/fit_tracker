
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fit_tracker/services/providers/database_helper.dart';
import 'package:fit_tracker/services/models/statistics.dart';
import 'package:fit_tracker/services/models/user.dart';
import 'package:fit_tracker/utils/global_context.dart';
import 'package:intl/intl.dart';

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
                future: dbHelper.getUserById(userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (userSnapshot.hasError) {
                    return Center(child: Text('Erro ao carregar dados do usuário'));
                  }

                  final user = userSnapshot.data!;

                  return FutureBuilder<Statistic>(
                    future: dbHelper.getStatisticsByUserId(userId),
                    builder: (context, statsSnapshot) {
                      if (statsSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (statsSnapshot.hasError) {
                        return Center(child: Text('Erro ao carregar estatísticas'));
                      }

                      final statistics = statsSnapshot.data!;
                      int birthDateMilliseconds = user.birthDate ?? 0;

                      // Formatar a data de nascimento
                      String formattedBirthDate = DateFormat('dd/MM/yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(birthDateMilliseconds),
                      );

                      return Column(
                        children: [
                          _buildProfileTile('NOME', '${user.firstName} ${user.lastName}'),
                          _buildProfileTile('DATA DE NASCIMENTO', formattedBirthDate),
                          _buildProfileTile('EMAIL', user.email),
                          _buildStatisticsTile(statistics),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            _buildEditButton(context, userId),
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
            _buildStatText('Último treino: ${_formatLastWorkout(statistics.lastWorkout)}', pLightRed), // Formatação
            _buildStatText('Número de amigos: ${statistics.totalFriends}', pLightRed),
          ],
        ),
      ),
    );
  }

  String _formatLastWorkout(DateTime? lastWorkout) {
    if (lastWorkout == null) {
      return 'Nenhum treino registrado'; // Retorna uma mensagem caso não haja último treino
    }

    // Formatação da data para o formato desejado (ex: 'dd/MM/yyyy')
    return DateFormat('dd/MM/yyyy').format(lastWorkout);
  }

  Widget _buildStatText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, color: color),
    );
  }

  Widget _buildEditButton(BuildContext context, int userId) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _showEditDialog(context, userId);
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

  void _showEditDialog(BuildContext context, int userId) {
    final dbHelper = DatabaseHelper();

    // Controladores de texto para os campos
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController(); // Controlador para a senha

    // Carregar os dados do usuário
    dbHelper.getUserById(userId).then((user) {
      firstNameController.text = user?.firstName ?? '';
      lastNameController.text = user?.lastName ?? '';
      emailController.text = user?.email ?? '';
      // A senha não deve ser preenchida para segurança
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Dados Pessoais'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Sobrenome'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController, // Campo de senha
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true, // Torna o texto da senha oculto
                ),
              ],
            ),
          ),
          actions: [
            // Usando Row para alinhar os botões com espaço entre eles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.cancel, color: pDarkRed), // Ícone de cancelar
                  onPressed: () {
                    Navigator.of(context).pop(); // Fechar o popup
                  },
                ),
                IconButton(
                  icon: Icon(Icons.check, color: pDarkRed), // Ícone de check
                  onPressed: () async {
                    // Verifica se a senha está vazia
                    if (passwordController.text.isEmpty) {
                      // Exibir um diálogo de erro ou uma mensagem de aviso
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('A senha é obrigatória!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // Não prosseguir se a senha estiver vazia
                    }

                    // Atualizar os dados do usuário
                    User updatedUser = User(
                      id: userId,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      password: passwordController.text, // Inclua a senha
                    );

                    // Chame a função para atualizar o usuário no banco de dados
                    await dbHelper.updateUser(updatedUser);
                    Navigator.of(context).pop(); // Fechar o popup
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
