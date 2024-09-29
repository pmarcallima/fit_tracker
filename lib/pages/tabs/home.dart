import 'package:fit_tracker/utils/images.dart';
import 'package:fit_tracker/widgets/features/home_buttons.dart';
import 'package:fit_tracker/widgets/features/login_buttons.dart';
import 'package:fit_tracker/widgets/features/login_form.dart';
import 'package:fit_tracker/widgets/features/login_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Texto centralizado
              Text.rich(
                TextSpan(
                  text: 'Fit Tracker', // texto padrão
                  style: GoogleFonts.blackHanSans(
                    fontStyle: FontStyle.italic,
                    fontSize: 40,
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          '\nDesafie amigos, \nalcance metas e ganhem juntos!',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              Image.asset(
                LOGO2,
                fit: BoxFit.fitHeight,
                width: 300,
              ),

              SizedBox(height: 30),
              HomeButtons(),
            ],
          ),
      ),
    );
  }
}
