
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomFormWidget extends StatefulWidget {
  @override
  _CustomFormWidgetState createState() => _CustomFormWidgetState();
}

class _CustomFormWidgetState extends State<CustomFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              fillColor: pWhite,
              filled: true,
              labelText: 'Usuário',
              labelStyle: TextStyle(color: pDarkGray), // Cor do texto do rótulo
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: pDarkGray),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: pLightGray, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: pRed, width: 2.0),
              ),
            ),
          ),
          SizedBox(height: 15), // Espaço entre os campos
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              fillColor: pWhite,
              filled: true,
              labelText: 'Senha',
              labelStyle: TextStyle(color: pDarkGray), // Cor do texto do rótulo
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: pDarkGray),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: pLightGray, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: pRed, width: 2.0),
              ),
            ),
            obscureText: true, // Para ocultar a senha
          ),
          SizedBox(height: 20), // Espaço entre campos e botão
        ],
      ),
    );
  }
}
