
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/widgets/features/workout_list.dart';
import 'package:fit_tracker/widgets/features/workout_list_test.dart';
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
      appBar: AppBar(
        toolbarHeight: 140,
        title: Text('Meus Treinos'),
        foregroundColor: pWhite,
        titleTextStyle: TextStyle(fontSize: 30),
        centerTitle: true,
        backgroundColor: pRed,
      ),
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
