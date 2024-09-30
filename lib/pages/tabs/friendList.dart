import 'package:fit_tracker/widgets/features/friend_list.dart';
import 'package:flutter/material.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/widgets/global/appbar.dart';

class FriendsListPageWrapper extends StatefulWidget {
  const FriendsListPageWrapper();

  @override
  State<FriendsListPageWrapper> createState() => _FriendsListPageWrapperState();
}

class _FriendsListPageWrapperState extends State<FriendsListPageWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Meus Amigos',
        icon: Icons.people_alt,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: pLightGray,
              child: Center(
                child: FriendsListPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FriendsListPageWrapper(),
  ));
}
