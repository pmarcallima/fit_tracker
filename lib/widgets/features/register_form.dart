import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/widgets/features/register_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
                text: 'Bem vindo', // texto padrão

                  style: GoogleFonts.blackHanSans(
                    fontSize: 22,

                  color: pDarkRed,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            SizedBox(height: 50),
            RegisterInput(),
          ],
        ),
      ),
    );
  }
}
