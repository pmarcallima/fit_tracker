import 'package:fit_tracker/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Importar o pacote para acessar a câmera

class FriendsListPage extends StatelessWidget {
  final List<Friend> friends = [
    Friend(name: "Pedro", streakDays: 5, hasStreak: true),
    Friend(name: "Bruno", streakDays: 0, hasStreak: false),
    Friend(name: "Gabriel", streakDays: 5, hasStreak: true),
    Friend(name: "Felipe", streakDays: 2, hasStreak: false),
  ];

  final ImagePicker _picker = ImagePicker(); // Instância para selecionar imagens

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return FriendTile(friend: friends[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInviteModal(context); // Chama o modal ao clicar no botão +
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
      ),
    );
  }

  // Função para exibir o modal com o código QR e o código de amigo
  void _showInviteModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 460, // Altura ajustada para incluir o botão
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza os itens verticalmente
              children: [
                Text(
                  'Convide seus amigos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Pelo código de amigo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.grey[200],
                  child: Text(
                    '#QSDF1',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Ou com código QR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                Image.asset(
                  QRCODE, // Caminho da imagem do QR Code
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 16),
                // Botão para abrir a câmera
                ElevatedButton.icon(
                  onPressed: () => _openCamera(),
                  icon: Icon(Icons.camera_alt),
                  label: Text('Abrir Câmera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Cor do botão
                    foregroundColor: Colors.white, // Cor do ícone e do texto
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Função para abrir a câmera
  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      print('Imagem capturada: ${photo.path}');
      // Aqui você pode adicionar lógica adicional para lidar com a imagem capturada.
    } else {
      print('Nenhuma imagem capturada.');
    }
  }
}

class Friend {
  final String name;
  final int streakDays;
  final bool hasStreak;

  Friend({required this.name, required this.streakDays, required this.hasStreak});
}

class FriendTile extends StatelessWidget {
  final Friend friend;

  const FriendTile({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getAvatarColor(friend.name),
          child: Text(
            friend.name[0], // Inicial do nome
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(friend.name),
        subtitle: Text('${friend.streakDays} dias'),
        trailing: friend.hasStreak ? Icon(Icons.whatshot, color: Colors.orange) : null,
        onTap: () {
          Navigator.pushNamed(context, '/personalData', arguments: friend);
        }, // Adiciona a navegação ao tocar no tile
      ),
    );
  }

  // Função para definir a cor do avatar baseado na primeira letra do nome
  Color _getAvatarColor(String name) {
    switch (name[0].toUpperCase()) {
      case 'P':
        return Colors.black;
      case 'B':
        return Colors.red;
      case 'G':
        return Colors.green;
      case 'F':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}

