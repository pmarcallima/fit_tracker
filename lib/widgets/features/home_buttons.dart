import 'package:fit_tracker/pages/tabs/home.dart';
import 'package:fit_tracker/pages/tabs/login.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width / 2.5,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjusts the size of the buttons
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pDarkRed,
              foregroundColor: pWhite,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text('Fazer login'),
          ),
          SizedBox(height: 8.0), // Space between buttons

          ElevatedButton(
            onPressed: () {

              Navigator.pushNamed(context, '/register');

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pLightBlack,
              foregroundColor: pWhite,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text('Criar uma conta'),
          ),
        ],
      ),
    );
  }
}
