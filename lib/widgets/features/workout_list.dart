

import 'package:fit_tracker/utils/colors.dart'; 
import 'package:flutter/material.dart';

class Exercise {
  String title;

  Exercise(this.title);
}

class Workout {
  String title;
  List<Exercise> exercises;

  Workout(this.title, this.exercises);
}

class WorkoutList extends StatefulWidget {
  const WorkoutList({super.key});

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  final workouts = List<Workout>.generate(
    10,
    (i) => Workout(
      'Workout $i',
      List<Exercise>.generate(
        5,
        (j) => Exercise('Exercise $j'),
      ),
    ),
  );

  void _showEditDialog(Exercise exercise, StateSetter updateParentState) {
    TextEditingController controller = TextEditingController(text: exercise.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Exercício'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Digite o novo nome"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  exercise.title = controller.text;
                });
                updateParentState(() {});
                Navigator.of(context).pop(); 
              },
              child: const Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showWorkoutPopup(BuildContext context, Workout workout) {
    TextEditingController workoutController = TextEditingController(text: workout.title);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              title: TextField(
                controller: workoutController,
                decoration: const InputDecoration(labelText: 'Título do Treino'),
              ),
              content: SizedBox(
                height: 300, 
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: workout.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = workout.exercises[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: Text(exercise.title),
                        onTap: () {
                          _showEditDialog(exercise, setState);
                        },
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      workout.title = workoutController.text; 
                    });
                    Navigator.of(context).pop(); 
                  },
                  child: const Text('Salvar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width / 1.5,
      height: screenSize.height / 1.5,
      child: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              tileColor: pLightGray,
              title: Text(workout.title),
              onTap: () => _showWorkoutPopup(context, workout),
            ),
          );
        },
      ),
    );
  }
}
