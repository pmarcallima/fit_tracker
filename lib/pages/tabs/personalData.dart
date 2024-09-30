import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/utils/images.dart';
import 'package:fit_tracker/widgets/features/personal_data.dart';
import 'package:fit_tracker/widgets/features/register_buttons.dart';
import 'package:fit_tracker/widgets/features/workout_list_test.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fit_tracker/widgets/global/appbar.dart';
import 'package:fit_tracker/widgets/global/bottombar.dart';


class PersonalDataPage extends StatefulWidget {
  const PersonalDataPage();

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Dados Pessoais',
        icon: Icons.account_circle,
        
      ),
      body:Flexible( 
        child: Column(
        children: <Widget>[
             Container(
              color: pLightGray, // Define o fundo branco para `PersonalData`
                child: PersonalData(), 
          ),

                CustomBottomBar(),
        ],
      ),
      ),
    );
  }
}
