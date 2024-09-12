
		import 'package:flutter/material.dart';

class ButtonColumnWidget extends StatelessWidget {
  final VoidCallback onLoginPressed;
  final VoidCallback onSignUpPressed;

  ButtonColumnWidget({
    required this.onLoginPressed,
    required this.onSignUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Adjusts the size of the buttons
      children: [
        ElevatedButton(
          onPressed: onLoginPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text('Fazer login'),
        ),
        SizedBox(height: 8.0), // Space between buttons
        ElevatedButton(
          onPressed: onSignUpPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff363636),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text('Criar uma conta'),
        ),
      ],
    );
  }
}
