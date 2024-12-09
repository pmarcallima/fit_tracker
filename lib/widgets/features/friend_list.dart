
import 'package:fit_tracker/services/models/friends.dart';
import 'package:fit_tracker/services/models/user.dart';
import 'package:fit_tracker/services/providers/firebase_helper.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/utils/global_context.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:fit_tracker/widgets/features/friend_data.dart';

class FriendsListPage extends StatefulWidget {
  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Friends> friends = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    try {
      User? user = await _firebaseService.getUserById(GlobalContext.userId!);

      if (user != null) {
        List<Friends> loadedFriends =
            await _firebaseService.getFriendList(user);
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
    } catch (e) {
      print("Erro ao carregar amigos: $e");
      setState(() {
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
                        var friend = friends[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            tileColor: pWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  friend.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: pBlack,
                                  ),
                                ),
                                if (friend.hasStreak)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(
                                      Icons.local_fire_department,
                                      color: Colors.orange,
                                    ),
                                  ),
                              ],
                            ),
                            onTap: () => _showFriendDataPopup(friend.id),
                          ),
                        );
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
    GlobalContext.friendId = friendId;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: FriendData(),
        );
      },
    );
  }

  void _showInviteModal(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 500,
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
                Text(
                  'Compartilhe seu QR Code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: pBlack,
                  ),
                ),
                QrImageView(
                  data: GlobalContext.userId!,
                  version: QrVersions.auto,
                  size: 150.0,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: pBlack,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: pBlack,
                  ),
                ),
                Text(
                  'Ou leia um QR Code para adicionar um amigo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: pBlack,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _scanQRCode(),
                  icon: Icon(Icons.qr_code_scanner),
                  label: Text('Ler QR Code'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pLightRed,
                    foregroundColor: pWhite,
                  ),
                ),
                Text(
                  'Ou procure um amigo pelo nome',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: pBlack,
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome do amigo',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    String name = nameController.text.trim();
                    print("chegou aqui");
                    if (name.isNotEmpty) {
                      User? user = await _firebaseService.getUserByName(name);
                      if (user != null) {
                        if (user.id != null) {
                          await _firebaseService.addFriend(user.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Amigo adicionado com sucesso!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('ID de usuário inválido!')),
                          );
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Amigo adicionado com sucesso!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Usuário não encontrado!')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Digite o nome do amigo!')),
                      );
                    }
                  },
                  child: Text('Adicionar Amigo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pRed,
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

  Future<void> _scanQRCode() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRCodeScannerPage(),
      ),
    );
  }
}

class QRCodeScannerPage extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ler QR Code'),
      ),
      body: QRView(
        key: GlobalKey(debugLabel: 'QR'),
        onQRViewCreated: (QRViewController controller) async {
          controller.scannedDataStream.listen((scanData) async {
            String scannedId = scanData.code ?? '';
            if (scannedId.isNotEmpty) {
              controller.dispose();

              await firebaseService.addFriend(scannedId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Amigo adicionado com sucesso!')),
              );
            }
          });
        },
      ),
    );
  }
}
