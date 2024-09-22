
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/widgets/features/login_buttons.dart';
import 'package:fit_tracker/widgets/features/login_input.dart';
import 'package:fit_tracker/widgets/features/register_buttons.dart';
import 'package:fit_tracker/widgets/features/register_input.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text.rich(
              TextSpan(
                text: 'Faça seu cadastro', // texto padrão
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 24,
                  color: pWhite,
                ),
              ),
            ),
            SizedBox(height: 50),
            RegisterInput(),
            SizedBox(height: 30),
            RegisterButtons(),
          ],
        ),
      ),
    );
  }
}
