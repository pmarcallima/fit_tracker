
import 'package:fit_tracker/main.dart';
import 'package:fit_tracker/pages/tabs/home.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';

class ButtonColumnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width / 3,
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/workouts');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pRed, 
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), 
              ),
              elevation: 5, 
            ),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: pLightGray, 
              ),
            ),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: pLightBlack,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 5,
            ),
            child: Text(
              'Cadastrar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: pLightGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
