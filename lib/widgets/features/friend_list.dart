import 'package:fit_tracker/services/models/friends.dart';
import 'package:fit_tracker/services/models/statistics.dart';
import 'package:fit_tracker/services/models/user.dart';
import 'package:fit_tracker/services/providers/firebase_helper.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/utils/global_context.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fit_tracker/utils/images.dart';

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
    final dbHelper = FirebaseService();
    User? user = await dbHelper.getUserById(GlobalContext.userId!);
    
    
    if (user != null) {
      List<Friends> loadedFriends = await dbHelper.getFriendList(user);
      setState(() {
        friends = loadedFriends;
        isLoading = false;
      });
    } else {
      print("Usuário não encontrado.");
      setState(() {
        friends = [];
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
                        return FriendTile(friend: friends[index], onTap: () {
                          _showFriendDataPopup(friends[index].id);
                        });
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

  void _showFriendDataPopup(String friendId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: FriendData(friendId: friendId),
        );
      },
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


class FriendData extends StatelessWidget {
  final String friendId;

  FriendData({required this.friendId});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();

    return FutureBuilder<User?>(
      future: dbHelper.getUserById(friendId),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (userSnapshot.hasError || userSnapshot.data == null) {
          return Center(child: Text('Erro ao carregar dados do usuário'));
        }

        final user = userSnapshot.data!;

        return FutureBuilder<Statistic?>(
          future: dbHelper.getStatisticsByUserId(friendId),
          builder: (context, statsSnapshot) {
            if (statsSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (statsSnapshot.hasError || statsSnapshot.data == null) {
              return Center(child: Text('Erro ao carregar estatísticas'));
            }

            final statistics = statsSnapshot.data!;

            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Exibir informações do usuário
                  _buildProfileTile('Nome', '${user.firstName} ${user.lastName}'),
                  _buildProfileTile('Data de Nascimento', '${DateTime.fromMillisecondsSinceEpoch(user.birthDate ?? 0)}'.split(' ')[0]),
                  _buildProfileTile('Email', user.email),

                  // Exibir informações de estatísticas
                  _buildProfileTile('Total de Treinos', statistics.totalWorkouts.toString()),
                  _buildProfileTile('Streak Atual', statistics.currentStreak.toString()),
                  _buildProfileTile('Maior Streak', statistics.biggestStreak.toString()),
                  _buildProfileTile('Total de Amigos', statistics.totalFriends.toString()),

                  const SizedBox(height: 20),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      Navigator.of(context).pop(); // Fecha o popup
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
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
}
class FriendTile extends StatelessWidget {
  final Friends friend;
  final Function() onTap;

  const FriendTile({Key? key, required this.friend, required this.onTap}) : super(key: key);

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
        onTap: onTap, // Chama a função passada quando clicado
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
