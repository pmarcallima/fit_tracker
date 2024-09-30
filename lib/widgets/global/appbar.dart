import 'package:fit_tracker/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:fit_tracker/utils/colors.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String titleText;
  final IconData icon;

  const CustomAppBar({Key? key, required this.titleText, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return
Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(BACKGROUND), 
              fit: BoxFit.fill, 
            ),
          ),
        ),

      AppBar(

      toolbarHeight: 120,
  title: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Icon(
            icon,
            size: 40.0, 
          ),
          SizedBox(height: 8.0), 
          Text(
            titleText,
            style: const TextStyle(fontSize: 30),
          ),
        ],
      ),
      foregroundColor: pWhite,
        titleTextStyle: TextStyle(fontSize: 30),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.checklist),
          tooltip: 'Treinos',
          onPressed: () {

              Navigator.pushNamed(context, '/workouts');
          },
        ),
        IconButton(
          icon: const Icon(Icons.group),
          tooltip: 'Amigos',
          onPressed: () {

              Navigator.pushNamed(context, '/');
          },
        ),
        IconButton(
          icon: const Icon(Icons.account_circle),
          tooltip: 'Perfil',
          onPressed: () {

              Navigator.pushNamed(context, '/personalData');
          },
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.home),
        tooltip: 'Menu Icon',
        onPressed: () {

              Navigator.pushNamed(context, '/home');
        },
      ),
          ),
        ],
    );
	}
 @override
  Size get preferredSize => const Size.fromHeight(120);
}
