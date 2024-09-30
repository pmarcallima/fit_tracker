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
              fit: BoxFit.fitWidth, 
            ),

          ),
        ),
 AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.transparent, // Torna a AppBar transparente
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 30.0,
              ),
              const SizedBox(height: 8.0),
              Text(
                titleText,
                style: const TextStyle(fontSize: 30),
              ),
            ],
          ),
          foregroundColor: pWhite,
          centerTitle: true,
leading: IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Home',
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ),
        ],
    );
	}
 @override
  Size get preferredSize => const Size.fromHeight(100);
}
