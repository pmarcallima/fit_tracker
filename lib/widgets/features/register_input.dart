import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';

class RegisterInput extends StatefulWidget {
  @override
  _RegisterInputState createState() => _RegisterInputState();
}

class _RegisterInputState extends State<RegisterInput> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              iconColor: Color(0xffEEEEEE),
                fillColor: pWhite, 
              filled: true,
              labelText: 'Usuário',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please enter your email';
            }),
        SizedBox(height: 15), // Space between fields
        TextFormField(
          decoration: InputDecoration(
            iconColor: Color(0xffDC5F00),
            fillColor: pWhite, 
            filled: true,
            labelText: 'Senha',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
