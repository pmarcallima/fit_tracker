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

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
    _monitorWorkoutChanges();
  }

  Future<void> _loadWorkouts() async {
    // Retrieve workouts for userId = 1
    workouts = await _databaseHelper.getAllWorkoutsByUserId(1);
    setState(() {}); // Refresh the UI once workouts are loaded
  }

  Future<List<Exercise>> _loadExercises(int id) async {
    List<Exercise> exercises = [];

    exercises = await _databaseHelper.getAllExercisesByWorkoutId(id);

    for (var exercise in exercises) {
      print(exercise.name);
    }

    return exercises;
  }

  void _onButtonPressed() {
    setState(() {
      buttonText = 'Treino confirmado';
    });
    _listUsers();
    print('connected user id: ${GlobalContext.userId}');
  }

  Future<void> _listUsers() async {
    List<User> _users = await _databaseHelper.getAllUsers();
    for (var user in _users) {
      int birthDateMilliseconds = user.birthDate ?? 0;
      print(
          'User: ${user.email}, Name: ${user.firstName} ${user.lastName}, id: ${user.id}, Birth Date: ${DateTime.fromMillisecondsSinceEpoch(birthDateMilliseconds)}');
    }
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
        id: workouts.length + 1,
        name: 'Novo Treino ${workouts.length + 1}',
        userId: 1);

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
        id: lastId + 1,
        workoutId: workoutId,
        name: '',
        description: '');
    _databaseHelper.insertExercise(novoExercicio);
  }

  Future<void> _updateExercise(exercise) async {
    await _databaseHelper.updateExercise(exercise); // Chama o método de atualização do banco
    setState(() {}); // Atualiza a interface para refletir a mudança
  }

  Future<void> deleteExercise(int exerciseId, int workoutId) async {
    int idDeletado = await _databaseHelper.deleteExercise(exerciseId, workoutId);
    setState(() {});
    print('deletado: ${idDeletado}');
  }


  void _removeWorkout(int index) async {
    // Obtém o ID do treino e o ID do usuário antes de remover da lista
    int workoutId = workouts[index].id;
    int userId = workouts[index].userId;

    // Remove o treino do banco de dados
    await DatabaseHelper().deleteWorkout(workoutId, userId);

    // Atualiza o estado e remove o treino da lista local
    setState(() {
      workouts.removeAt(index);
    });
  }

  void _showEditDialog(Exercise exercise, StateSetter updateParentState) {
    var screenSize = MediaQuery.of(context).size;
    TextEditingController exerciseController = TextEditingController(text: exercise.name);
    TextEditingController descriptionController = TextEditingController(text: exercise.description);

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
                  updateParentState(() {}); // Atualiza o estado do parent para refletir a nova imagem
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
                        exercise.name = exerciseController.text; // Atualiza o nome do exercício
                        exercise.description = descriptionController.text;
                        await _updateExercise(exercise); // Salva as mudanças no banco de dados
                        updateParentState(() {}); // Atualiza a interface principal
                        Navigator.of(context).pop();
                      },
                      color: Colors.green,
                      icon: Icon(Icons.check_circle),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: pDarkerRed),
                      onPressed: () async {
                        await deleteExercise(exercise.id, exercise.workoutId);
                        setState(() {}); // Atualiza a lista de exercícios na interface
                        updateParentState(() {}); // Atualiza o estado do diálogo
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
                  future: _loadExercises(workout.id),
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
                              title: Text(exercise.name == '' ? 'Adicione um nome' : exercise.name),
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
                        workout.name ??
                            'Unnamed Workout', // Provide a default value if name is null
                        style: TextStyle(
                          color: pBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '0 exercícios',
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
