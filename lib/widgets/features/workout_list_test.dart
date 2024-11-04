import 'package:fit_tracker/services/models/exercise.dart';
import 'package:fit_tracker/services/models/user.dart';
import 'package:fit_tracker/services/models/workout.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fit_tracker/services/providers/database_helper.dart';
import 'package:fit_tracker/utils/global_context.dart';

import 'dart:io';

final DatabaseHelper _databaseHelper = DatabaseHelper();

class WorkoutListT extends StatefulWidget {
  const WorkoutListT({super.key});

  @override
  State<WorkoutListT> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutListT> {
  String buttonText = 'Confirmar treino';
  List<Workout> workouts = [];
  DateTime?
      lastWorkoutDate; // Field to track the last workout confirmation date
  int totalWorkouts = 0;
  int biggestStreak = 0;
  int currentStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
    _loadUserStatistics();
    _monitorWorkoutChanges();
  }

  Future<void> _loadWorkouts() async {
    workouts =
        await _databaseHelper.getAllWorkoutsByUserId(GlobalContext.userId ?? 0);
    setState(() {}); // Refresh the UI once workouts are loaded
  }

  Future<void> _loadUserStatistics() async {
    var stats =
        await _databaseHelper.getUserStatistics(GlobalContext.userId ?? 0);
    lastWorkoutDate = stats?.lastWorkout ?? null;
    totalWorkouts = stats?.totalWorkouts ?? 0;
    biggestStreak = stats?.biggestStreak ?? 0;
    currentStreak = stats?.currentStreak ?? 0;
    setState(() {}); // Update UI with the loaded statistics
  }

  void _onButtonPressed() async {
    DateTime today = DateTime.now();

    // Check if the button was already pressed today
    if (lastWorkoutDate != null &&
        lastWorkoutDate!.day == today.day &&
        lastWorkoutDate!.month == today.month &&
        lastWorkoutDate!.year == today.year) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Você já confirmou o treino hoje!")),
      );
      return;
    }

    // Calculate the difference in days from the last workout
    int daysSinceLastWorkout = lastWorkoutDate != null
        ? today.difference(lastWorkoutDate!).inDays
        : 0;

    // Determine if we reset or increment the current streak
    if (daysSinceLastWorkout == 1) {
      // Increment streak if last workout was yesterday
      currentStreak++;
    } else if (daysSinceLastWorkout > 1) {
      // Reset streak if more than one day has passed
      currentStreak = 1;
    }

    totalWorkouts++;

    // Update the biggest streak if the current streak exceeds it
    if (currentStreak > biggestStreak) {
      biggestStreak = currentStreak;
    }

    // Update the button text and record the workout date
    setState(() {
      buttonText = 'Treino confirmado';
      lastWorkoutDate = today;
    });

    // Update statistics in the database
    await _databaseHelper.updateUserStatistics(
      GlobalContext.userId ?? 0,
      lastWorkoutDate: today,
      totalWorkouts: totalWorkouts,
      currentStreak: currentStreak,
      biggestStreak: biggestStreak,
    );

    print('Connected user id: ${GlobalContext.userId}');
  }


  Future<List<Exercise>> _loadExercises(int workoutId) async {
    return await _databaseHelper.getAllExercisesByWorkoutId(workoutId);
  }

  void _monitorWorkoutChanges() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var workout in workouts) {
        debugPrint('Monitorei o treino: ${workout.name}');
      }
    });
  }

  Future<void> _pickImage(Exercise exercise) async {
    var picked = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (picked != null && picked.files.first.bytes != null) {
      setState(() {
        exercise.image = picked
            .files.first.bytes; // Assigns Uint8List data to exercise.image
      });
    }
  }

  void _addWorkout() async {
    var novoTreino = Workout(
      name: 'Novo Treino ${workouts.length + 1}',
      userId: GlobalContext.userId ?? 0,
    );

    // Insere o novo treino no banco de dados
    await _databaseHelper.insertWorkout(novoTreino);

    // Recarrega a lista de treinos após a inserção
    await _loadWorkouts();
  }

  Future<void> _addExercise(workoutId) async {
    var lastId = -1;
    var treinos = await _databaseHelper.getAllExercisesByWorkoutId(workoutId);

    for (var exercicio in treinos) {
      if (exercicio.id != null) {
        if (exercicio.id > lastId) {
          lastId = exercicio.id;
        }
      }
    }

    var novoExercicio = Exercise(
        id: lastId + 1, workoutId: workoutId, name: '', description: '');
    _databaseHelper.insertExercise(novoExercicio);
  }

  Future<void> _updateExercise(exercise) async {
    await _databaseHelper
        .updateExercise(exercise); // Chama o método de atualização do banco
    setState(() {}); // Atualiza a interface para refletir a mudança
  }

  Future<void> deleteExercise(int exerciseId, int workoutId) async {
    int idDeletado =
        await _databaseHelper.deleteExercise(exerciseId, workoutId);
    setState(() {});
    print('deletado: ${idDeletado}');
  }

  void _removeWorkout(int index) async {
    // Obtém o ID do treino e o ID do usuário antes de remover da lista
    int? workoutId = workouts[index].id; // workoutId is nullable
    int userId = workouts[index].userId;

    // Verifica se workoutId não é nulo antes de deletar
    if (workoutId != null) {
      // Remove o treino do banco de dados
      await DatabaseHelper().deleteWorkout(workoutId, userId);

      // Atualiza o estado e remove o treino da lista local
      setState(() {
        workouts.removeAt(index);
      });
    } else {
      print("Erro: ID do treino é nulo e não pode ser removido.");
    }
  }

  Future<int> _getExerciseCount(int workoutId) async {
    List<Exercise> exercicios = await _loadExercises(workoutId);
    return exercicios.length;
  }

  void _showEditDialog(Exercise exercise, StateSetter updateParentState) {
    var screenSize = MediaQuery.of(context).size;
    TextEditingController exerciseController =
        TextEditingController(text: exercise.name);
    TextEditingController descriptionController =
        TextEditingController(text: exercise.description);

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
                    labelText: 'Nome do exercício',
                    labelStyle: TextStyle(color: pDarkerRed),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: pRed, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: screenSize.width / 1.5,
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Descrição',
                    labelStyle: TextStyle(color: pDarkerRed),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: pRed, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 100,
                width: 100,
                child: exercise.image != null
                    ? Image.memory(
                        exercise.image!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.image, size: 50),
                      ),
              ),
              SizedBox(height: 20),
              IconButton(
                iconSize: 80,
                icon: Icon(Icons.file_upload_outlined, color: pDarkRed),
                onPressed: () async {
                  await _pickImage(exercise);
                  updateParentState(
                      () {}); // Atualiza o estado do parent para refletir a nova imagem
                },
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
                      onPressed: () async {
                        exercise.name = exerciseController
                            .text; // Atualiza o nome do exercício
                        exercise.description = descriptionController.text;
                        await _updateExercise(
                            exercise); // Salva as mudanças no banco de dados
                        updateParentState(
                            () {}); // Atualiza a interface principal
                        Navigator.of(context).pop();
                      },
                      color: Colors.green,
                      icon: Icon(Icons.check_circle),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: pDarkerRed),
                      onPressed: () async {
                        await deleteExercise(exercise.id, exercise.workoutId);
                        setState(
                            () {}); // Atualiza a lista de exercícios na interface
                        updateParentState(
                            () {}); // Atualiza o estado do diálogo
                        Navigator.of(context).pop();
                      },
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
        TextEditingController(text: workout.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to have access to setState within the dialog
          builder: (context, setState) {
            return AlertDialog(
              title: TextField(
                controller: workoutController,
                decoration:
                    const InputDecoration(labelText: 'Título do Treino'),
              ),
              content: SizedBox(
                height: 300,
                width: double.maxFinite,
                child: FutureBuilder<List<Exercise>>(
                  future: workout.id != null
                      ? _loadExercises(workout.id!)
                      : Future.value([]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar exercícios'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text('Adicione exercícios ao seu treino'));
                    } else {
                      final exercises = snapshot.data!;
                      return ListView.builder(
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              tileColor: pLightGray,
                              title: Text(exercise.name == ''
                                  ? 'Adicione um nome'
                                  : exercise.name),
                              leading: exercise.image != null
                                  ? CircleAvatar(
                                      backgroundImage: exercise.image != null
                                          ? MemoryImage(exercise.image!)
                                          : null,
                                      child: exercise.image == null
                                          ? Icon(Icons.image)
                                          : null,
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
                      );
                    }
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
                    ElevatedButton(
                      onPressed: () async {
                        await _addExercise(workout.id); // Add exercise
                        setState(
                            () {}); // Refresh the dialog to show the updated list
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        shape: CircleBorder(),
                        elevation: 8,
                        backgroundColor: pRed,
                      ),
                      child: Icon(Icons.add, size: 30, color: pWhite),
                    ),
                    IconButton(
                      onPressed: () async {
                        workout.name = workoutController.text;

                        // Atualiza o treino no banco de dados
                        await _databaseHelper.updateWorkout(workout);

                        // Recarrega a lista de treinos para refletir as mudanças
                        await _loadWorkouts();

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
                        workout.name ?? 'Unnamed Workout',
                        style: TextStyle(
                          color: pBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: FutureBuilder<int>(
                        future: workout.id != null
                            ? _getExerciseCount(workout.id!)
                            : Future.value(0), // Return 0 if workout.id is null
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              'Loading...',
                              style: TextStyle(color: pGray),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error loading exercises',
                              style: TextStyle(color: pGray),
                            );
                          } else {
                            return Text(
                              '${snapshot.data} exercícios',
                              style: TextStyle(color: pGray),
                            );
                          }
                        },
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
