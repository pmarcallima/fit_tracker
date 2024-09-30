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
    // Navega para a página correspondente ao índice selecionado
    switch (index) {
      case 0:
      // Navega para a página de treinos sem empilhar
        Navigator.pushReplacementNamed(context, '/workouts');
        break;
      case 1:
      // Navega para a página de amigos sem empilhar
        Navigator.pushReplacementNamed(context, '/friendList');
        break;
      case 2:
      // Navega para a página de perfil sem empilhar
        Navigator.pushReplacementNamed(context, '/personalData');
        break;
      case 3:
      // Navega para a página sobre nós sem empilhar
        Navigator.pushReplacementNamed(context, '/aboutUs');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex, // Destaque o índice selecionado
      onTap: _onItemTapped, // Gerencia o toque nos itens de navegação
      type: BottomNavigationBarType.fixed, // Garante que todos os itens sejam exibidos
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
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Sobre nós',
        ),
      ],
      selectedItemColor: Colors.blue, // Cor do item selecionado
      unselectedItemColor: Colors.grey, // Cor dos itens não selecionados
    );
  }
}
