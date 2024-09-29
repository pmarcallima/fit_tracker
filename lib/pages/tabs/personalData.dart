import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/utils/images.dart';
import 'package:fit_tracker/widgets/features/personal_data.dart';
import 'package:fit_tracker/widgets/features/register_buttons.dart';
import 'package:fit_tracker/widgets/features/workout_list_test.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class PersonalDataPage extends StatefulWidget {
  const PersonalDataPage();

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: <Widget>[
          // Cabeçalho com ícone e texto "Dados Pessoais"
          Container(
            width: double.infinity,
            color: pDarkRed, // Fundo padrão para o cabeçalho
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Image.asset(
                  USERICON,
                  fit: BoxFit.fitHeight,
                  width: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  'Dados Pessoais',
                  style: GoogleFonts.blackHanSans(
                    fontSize: 30,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          // Corpo com o fundo branco e o widget `PersonalData`
          Expanded(
            child: Container(
              color: pLightGray, // Define o fundo branco para `PersonalData`
              child: Center(
                child: PersonalData(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
