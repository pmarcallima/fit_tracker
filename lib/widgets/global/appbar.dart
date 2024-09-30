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
        ],
    );
	}
 @override
  Size get preferredSize => const Size.fromHeight(120);
}
