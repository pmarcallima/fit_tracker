
import 'package:flutter/material.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Navigate to the respective page based on the selected index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/workouts'); // Navigate to workouts page
        break;
      case 1:
        Navigator.pushNamed(context, '/friends'); // Navigate to friends page
        break;
      case 2:
        Navigator.pushNamed(context, '/personalData'); // Navigate to profile page
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex, // Highlight the selected index
      onTap: _onItemTapped, // Handle tap on the navigation items
      items: const [
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
      ],
    );
  }
}
