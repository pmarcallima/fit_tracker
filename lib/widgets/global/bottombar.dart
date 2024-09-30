
import 'package:flutter/material.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex; // Índice atual recebido como parâmetro

  const CustomBottomBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  void _onItemTapped(int index) {
    Navigator.pushReplacementNamed(context, index == 0
        ? '/workouts'
        : index == 1
            ? '/friendList'
            : index == 2
                ? '/personalData'
                : '/aboutUs');
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.checklist),
          label: 'Treinos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Amigos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Sobre nós',
        ),
      ],
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
    );
  }
}
