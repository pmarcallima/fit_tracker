
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Menu Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
