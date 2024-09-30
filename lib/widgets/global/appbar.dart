import 'package:fit_tracker/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter_svg/svg.dart';
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
  child: SvgPicture.asset(
            BACKGROUND, // Usando SvgPicture para carregar a imagem
            fit: BoxFit.cover, // Ajusta a imagem para cobrir toda a área
            width: double.infinity, // Largura total
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
