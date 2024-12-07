
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/widgets/features/workout_list.dart';
import 'package:fit_tracker/widgets/features/workout_list_test.dart';
import 'package:fit_tracker/widgets/global/appbar.dart';
import 'package:fit_tracker/widgets/global/bottombar.dart';
import 'package:flutter/material.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage();

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Treinos', icon: Icons.checklist),
      body: Column(
        children: <Widget>[
          SizedBox(height: 30),
          Expanded(
            child: WorkoutListT(), // O Expanded deve envolver o widget de lista
          ),
          CustomBottomBar(currentIndex: 0),
        ],
      ),
    );
  }
}
