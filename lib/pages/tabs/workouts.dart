
import 'package:fit_tracker/widgets/features/workout_list.dart';
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Texto centralizado
              Text.rich(
                TextSpan(
                  text: 'Treinos', 
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

            WorkoutList(),

            ],
          ),
      ),
    );
  }
}
