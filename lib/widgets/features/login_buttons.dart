import 'package:fit_tracker/main.dart';
import 'package:fit_tracker/pages/tabs/home.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';

class ButtonColumnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width/3,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjusts the size of the buttons
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
                Navigator.pushNamed(context, '/workouts');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pRed,
              foregroundColor: pLightGray,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text('Fazer login'),
          ),
          SizedBox(height: 10.0), // Space between buttons
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: pLightBlack,
              foregroundColor: pLightGray,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text('Criar uma conta'),
          ),
        ],
      ),
    );
  }
}
