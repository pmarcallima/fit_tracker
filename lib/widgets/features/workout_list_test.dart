
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class Exercise {
  String title;
  String? imagePath;

  Exercise(this.title, {this.imagePath});
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
  String buttonText = 'Confirmar treino';
  final workouts = <Workout>[];

  @override
  void initState() {
    super.initState();
    workouts.addAll(List<Workout>.generate(
      10,
      (i) => Workout(
        'Treino $i',
        List<Exercise>.generate(
          5,
          (j) => Exercise('Exercício $j'),
        ),
      ),
    ));
    _monitorWorkoutChanges();
  }

  void _onButtonPressed() {
    setState(() {
      buttonText = 'Treino confirmado';
    });
  }

  void _monitorWorkoutChanges() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
      for (var workout in workouts) {
        debugPrint('Monitorei o treino: ${workout.title}');
      }
    });
  }

  Future<void> _pickImage(Exercise exercise) async {
    var picked = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (picked != null) {
      setState(() {
        exercise.imagePath = picked.files.first.path;
      });
    }
  }

  void _showEditDialog(Exercise exercise, StateSetter updateParentState) {
    var screenSize = MediaQuery.of(context).size;
    TextEditingController exerciseController = TextEditingController(text: exercise.title);

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: screenSize.width / 1.5,
                child: TextField(
                  controller: exerciseController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Exercício',
                    labelStyle: TextStyle(color: pDarkerRed),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: pRed, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              exercise.imagePath != null
                  ? Image.file(
                      File(exercise.imagePath!),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : SizedBox(height: 100, width: 100, child: Container(color: Colors.grey[300], child: Icon(Icons.image))),
              SizedBox(height: 20),
              IconButton(
                iconSize: 80,
                icon: Icon(Icons.file_upload_outlined, color: pDarkRed),
                onPressed: () => _pickImage(exercise),
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close),
                      color: pDarkerRed,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          exercise.title = exerciseController.text;
                        });
                        updateParentState(() {});
                        Navigator.of(context).pop();
                      },
                      color: Colors.green,
                      icon: Icon(Icons.check_circle),
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

  void _showWorkoutPopup(BuildContext context, Workout workout, int workoutIndex) {
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        tileColor: pLightGray,
                        title: Text(exercise.title),
                        leading: exercise.imagePath != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(File(exercise.imagePath!)),
                              )
                            : CircleAvatar(
                                child: Icon(Icons.image),
                              ),
                        onTap: () {
                          _showEditDialog(exercise, setState);
                        },
                      ),
                    );
                  },
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: pDarkerRed,
                      icon: Icon(Icons.close),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          workout.title = workoutController.text;
                        });
                        _monitorWorkoutChanges();
                        Navigator.of(context).pop();
                      },
                      color: Colors.green,
                      icon: Icon(Icons.check_circle),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addWorkout() {
    setState(() {
      workouts.add(Workout('Novo Treino', []));
    });
  }

  void _removeWorkout(int index) {
    setState(() {
      workouts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width / 1.5,
      height: screenSize.height / 1.5,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _onButtonPressed,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 8,
              backgroundColor: pRed,
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: pWhite,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.thumb_up, size: 30, color: pWhite),
                SizedBox(width: 10),
                Text(buttonText, style: TextStyle(color: pWhite)),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    color: pWhite,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(
                        workout.title,
                        style: TextStyle(color: pBlack, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${workout.exercises.length} exercícios',
                        style: TextStyle(color: pGray),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: pDarkerRed),
                        onPressed: () {
                          _removeWorkout(index);
                        },
                      ),
                      onTap: () {
                        _showWorkoutPopup(context, workout, index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addWorkout,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15),
              shape: CircleBorder(),
              elevation: 8,
              backgroundColor: pRed,
            ),
            child: Icon(Icons.add, size: 30, color: pWhite),
          ),
        ],
      ),
    );
  }
}
