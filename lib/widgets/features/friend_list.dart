
import 'package:fit_tracker/services/models/friends.dart';
import 'package:fit_tracker/services/models/user.dart';
import 'package:fit_tracker/services/providers/database_helper.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/utils/global_context.dart';
import 'package:fit_tracker/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FriendsListPage extends StatefulWidget {
  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  final ImagePicker _picker = ImagePicker();
  List<Friends> friends = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

Future<void> _loadFriends() async {
  final dbHelper = DatabaseHelper();

  // Tenta carregar o usuário pelo ID no GlobalContext
  User? user = await dbHelper.getUserById(GlobalContext.userId!);
  
  // Verifica se o usuário foi encontrado antes de chamar getFriendList
  if (user != null) {
    List<Friends> loadedFriends = await dbHelper.getFriendList(user);
    setState(() {
      friends = loadedFriends;
      isLoading = false;
    });
  } else {
    // Lida com o caso de usuário não encontrado (opcional)
    print("Usuário não encontrado.");
    setState(() {
      friends = []; // Limpa a lista de amigos
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: pLightGray,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: screenSize.width,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        return FriendTile(friend: friends[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInviteModal(context);
        },
        backgroundColor: pRed,
        foregroundColor: pLightGray,
        child: Icon(Icons.add, size: 30),
      ),
    );
  }

  void _showInviteModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Convide seus amigos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: pDarkerRed,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Pelo código de amigo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: pBlack,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: pLightGray2,
                    borderRadius: BorderRadius.circular(8),
                  ),
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
                    color: pBlack,
                  ),
                ),
                SizedBox(height: 16),
                Image.asset(
                  QRCODE,
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _openCamera(),
                  icon: Icon(Icons.camera_alt),
                  label: Text('Abrir Câmera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pLightRed,
                    foregroundColor: pWhite,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      print('Imagem capturada: ${photo.path}');
    } else {
      print('Nenhuma imagem capturada.');
    }
  }
}


class FriendTile extends StatelessWidget {
  final Friends friend;

  const FriendTile({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: pWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getAvatarColor(friend.name),
          child: Text(
            friend.name[0],
            style: TextStyle(color: pWhite),
          ),
        ),
        title: Text(
          friend.name,
          style: TextStyle(color: pBlack, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${friend.streakDays} dias',
          style: TextStyle(color: pGray),
        ),
        trailing: friend.hasStreak
            ? Icon(Icons.whatshot, color: pRed)
            : null,
        onTap: () {
          GlobalContext.friendId = friend.id;
          Navigator.pushNamed(context, '/friendData', );
        },
      ),
    );
  }

  Color _getAvatarColor(String name) {
    switch (name[0].toUpperCase()) {
      case 'P':
        return pBlack;
      case 'B':
        return pRed;
      case 'G':
        return Colors.green;
      case 'F':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}
