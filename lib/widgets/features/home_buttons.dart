
import 'package:fit_tracker/pages/tabs/home.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeButtons extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Adjusts the size of the buttons
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
          ElevatedButton(
          onPressed: () {

                  // Define what happens when the login button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: pWhite,
            foregroundColor: pLightRed, 
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text('Fazer login'),
        ),
        SizedBox(height: 8.0), // Space between buttons
        ElevatedButton(
          onPressed:(){} ,
          style: ElevatedButton.styleFrom(
            backgroundColor: pLightBlack,
            foregroundColor: pWhite,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text('Criar uma conta'),
        ),
      ],
    );
  }
}
