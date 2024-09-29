import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/widgets/features/login_buttons.dart';
import 'package:fit_tracker/widgets/features/login_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
                text: 'Bem vindo de volta', // texto padrão

                  style: GoogleFonts.blackHanSans(
                    fontSize: 22,

                  color: pDarkRed,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            SizedBox(height: 120),
            CustomFormWidget(),
            SizedBox(height: 30),
            ButtonColumnWidget(),
          ],
        ),
      ),
    );
  }
}
