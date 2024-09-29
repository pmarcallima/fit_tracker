import 'package:fit_tracker/widgets/features/login_form.dart';
import 'package:fit_tracker/widgets/features/register_form.dart';
import 'package:flutter/material.dart';
import 'package:fit_tracker/utils/colors.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        toolbarHeight: 140,
        title: Text('Cadastro'),
        foregroundColor: pWhite,
        titleTextStyle: TextStyle(fontSize: 30),
        centerTitle: true,
        backgroundColor: pRed,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
