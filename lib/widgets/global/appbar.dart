import 'package:flutter/material.dart';
import 'package:fit_tracker/utils/colors.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String titleText;

  const CustomAppBar({Key? key, required this.titleText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titleText),
      foregroundColor: pWhite,
        titleTextStyle: TextStyle(fontSize: 30),
        centerTitle: true,
        backgroundColor: pRed,
      
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.comment),
          tooltip: 'Comment Icon',
          onPressed: () {

              Navigator.pushNamed(context, '/home');

          },
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Setting Icon',
          onPressed: () {},
        ),
      ],
      elevation: 50.0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        tooltip: 'Menu Icon',
        onPressed: () {},
      ),
    );
	}
 @override
  Size get preferredSize => const Size.fromHeight(120);
}
