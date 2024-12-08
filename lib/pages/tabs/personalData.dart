import 'package:fit_tracker/pages/tabs/home.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/widgets/features/personal_data.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Dados Pessoais',
        icon: Icons.account_circle,
      ),
      body: Row(
        children: [
          Flexible(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                  color: pLightGray,
                  child: PersonalData(),
                ),
                Expanded(child: Container()),
                CustomBottomBar(currentIndex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
