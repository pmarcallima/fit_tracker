import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Exercise {
  String title;

  Exercise(this.title);
}

class Workout {
  String title;
  List<Exercise> exercises;

  Workout(this.title, this.exercises);
}

class WorkoutListT extends StatefulWidget {
  const WorkoutListT({super.key});

  @override
  State<WorkoutListT> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutListT> {
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

  @override
  void initState() {
    super.initState();
    // Simulando um useEffect que escuta mudanças no workout
    _monitorWorkoutChanges();
  }

  // Função que "monitora" as mudanças em workout
  void _monitorWorkoutChanges() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Isso força uma atualização na tela
      });
      for (var workout in workouts) {
        debugPrint('Monitorei o treino: ${workout.title}');
      }
    });
  }

  void _showEditDialog(Exercise exercise, StateSetter updateParentState) {
    var screenSize = MediaQuery.of(context).size;

    TextEditingController exerciseController =
        TextEditingController(text: exercise.title);

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: screenSize.width / 2,
                child: TextField(
                  controller: exerciseController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(height: 50),
              IconButton(
                iconSize: 100,
                icon: Icon(Icons.file_upload_outlined),
                onPressed: () async {
                  var picked = await FilePicker.platform.pickFiles();

                  if (picked != null) {
                    print(picked.files.first.name);
                  }
                },
              ),

              SizedBox(height: 50),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: const Text('Salvar'),
                      onPressed: () {
                        setState(() {
                          exercise.title = exerciseController.text;
                        });
                        updateParentState(() {});
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Fechar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
         
            ],
          ),
        );
      },
    );
  }

  void _showWorkoutPopup(
      BuildContext context, Workout workout, int workoutIndex) {
    TextEditingController workoutController =
        TextEditingController(text: workout.title);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              title: TextField(
                controller: workoutController,
                decoration:
                    const InputDecoration(labelText: 'Título do Treino'),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
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
                    _monitorWorkoutChanges();
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              tileColor: pLightGray,
              title: Text(workout.title),
              onTap: () {
                _showWorkoutPopup(context, workout, index);
              },
            ),
          );
        },
      ),
    );
  }
}
