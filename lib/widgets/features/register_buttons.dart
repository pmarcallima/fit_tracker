
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';

class RegisterButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width/3,
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {

                Navigator.pushNamed(context, '/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pRed,
              foregroundColor: pWhite,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text('Cadastrar'),
          ),
          SizedBox(height: 8.0), 
        ],
      ),
    );
  }
}
