
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/widgets/features/workout_list.dart';
import 'package:fit_tracker/widgets/features/workout_list_test.dart';
import 'package:fit_tracker/widgets/global/appbar.dart';
import 'package:flutter/material.dart';


class WorkoutsPage extends StatefulWidget {

  const WorkoutsPage();

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Treinos', icon: Icons.checklist),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Texto centralizado
              SizedBox(height: 30),

              WorkoutListT(),

            ],
          ),
      ),
    );
  }
}
