
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fit_tracker/widgets/global/appbar.dart';
import 'package:fit_tracker/widgets/global/bottombar.dart';
import 'package:fit_tracker/widgets/features/friend_data.dart';


class FriendDataPage extends StatefulWidget {
  const FriendDataPage();


  @override
  State<FriendDataPage> createState() => _FriendDataPageState();
}

class _FriendDataPageState extends State<FriendDataPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Dados Pessoais',
        icon: Icons.account_circle,
        
      ),
      body:Flexible( 
        child: Column(
        children: <Widget>[
             Container(
              color: pLightGray, 
                child: FriendData(), 
          ),

Expanded(child: Container()),
                CustomBottomBar(currentIndex: 1,),
        ],
      ),
      ),
    );
  }
}
