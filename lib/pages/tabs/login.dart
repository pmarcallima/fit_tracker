import 'package:fit_tracker/pages/tabs/home.dart';
import 'package:fit_tracker/widgets/features/login_buttons.dart';
import 'package:fit_tracker/widgets/features/login_input.dart';
import 'package:fit_tracker/widgets/features/menu.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                

                CustomFormWidget(),
                ButtonColumnWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
