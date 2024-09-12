
import 'package:flutter/material.dart';

class CustomFormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                iconColor: Color(0xffEEEEEE),
                fillColor: Color(0xffEEEEEE),
                filled: true,
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15), // Space between fields
            TextFormField(
              decoration: InputDecoration(
                iconColor: Color(0xffDC5F00),
                fillColor: Color(0xffEEEEEE),
                filled: true,
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
