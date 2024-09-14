import 'package:fit_tracker/widgets/features/login_buttons.dart';
import 'package:fit_tracker/widgets/features/login_form.dart';
import 'package:fit_tracker/widgets/features/login_input.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          children: [
        

         LoginForm(),
],
          ),
        ),
    );
  }
}
