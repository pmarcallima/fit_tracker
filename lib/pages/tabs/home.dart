import 'package:fit_tracker/utils/images.dart';
import 'package:fit_tracker/widgets/features/home_buttons.dart';
import 'package:fit_tracker/widgets/features/login_form.dart';
import 'package:fit_tracker/widgets/features/login_input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fit_tracker/utils/colors.dart';


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
      body: Stack(
      children: [ 
Container(
            width: screenSize.width,
            height: screenSize.height,
            child: Image.asset(
            BACKGROUND, 
            fit: BoxFit.fill, 
          ),
          ),

          Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text.rich(
                TextSpan(
                  text: 'Fit Tracker', 
                  style: GoogleFonts.blackHanSans(
                    fontStyle: FontStyle.italic,
                    fontSize: 40,
                    color: pWhite,
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
                LOGO,
                fit: BoxFit.fitHeight,
                width: 300,
              ),

              SizedBox(height: 30),
              HomeButtons(),
            ],
          ),
      ),
        ],
      ),
    );
  }
}
