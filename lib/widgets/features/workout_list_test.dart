import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:fit_tracker/utils/global_context.dart';
import 'package:fit_tracker/services/models/exercise.dart';
import 'package:fit_tracker/services/models/workout.dart';
import 'package:fit_tracker/services/models/statistics.dart';
import 'dart:typed_data';

class WorkoutListT extends StatefulWidget {
const WorkoutListT({super.key});

@override
State<WorkoutListT> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutListT> {
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
String buttonText = 'Confirmar treino';
DateTime? lastWorkoutDate;
int totalWorkouts = 0;
int biggestStreak = 0;
int currentStreak = 0;

@override
void initState() {
  super.initState();
  _loadUserStatistics();
}

Future<void> _loadUserStatistics() async {
  var userStatsDoc = await _firestore
      .collection('userStatistics')
      .doc("oi")
      .get();

  if (userStatsDoc.exists) {
    var stats = Statistic.fromFirestore(userStatsDoc.data()!);
    setState(() {
      lastWorkoutDate = stats.lastWorkout;
      totalWorkouts = stats.totalWorkouts;
      biggestStreak = stats.biggestStreak;
      currentStreak = stats.currentStreak;
    });
  }
}

void _onButtonPressed() async {
  DateTime today = DateTime.now();

  if (lastWorkoutDate != null &&
      lastWorkoutDate!.day == today.day &&
      lastWorkoutDate!.month == today.month &&
      lastWorkoutDate!.year == today.year) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Você já confirmou o treino hoje!")),
    );
    return;
  }

  int daysSinceLastWorkout =
      lastWorkoutDate != null ? today.difference(lastWorkoutDate!).inDays : 0;

  if (daysSinceLastWorkout == 1) {
    currentStreak++;
  } else if (daysSinceLastWorkout > 1) {
    currentStreak = 1;
  }

  totalWorkouts++;

  if (currentStreak > biggestStreak) {
    biggestStreak = currentStreak;
  }

  setState(() {
    buttonText = 'Treino confirmado';
    lastWorkoutDate = today;
  });

  await _firestore.collection('userStatistics').doc("oi").set({
    'lastWorkout': today,
    'totalWorkouts': totalWorkouts,
    'currentStreak': currentStreak,
    'biggestStreak': biggestStreak,
  });
}
Future<void> _pickImage(Exercise exercise) async {
  var picked = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );
  if (picked != null && picked.files.first.bytes != null) {
    setState(() {
      exercise.image = picked.files.first.bytes;
    });
    if (exercise.id != null) {
      await _firestore
          .collection('exercises')
          .doc(exercise.id)
          .update({'image': exercise.image});
    }
  }
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
            SizedBox(
              width: screenSize.width / 1.5,
              child: TextField(
                controller: exerciseController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Nome do exercício',
                  labelStyle: TextStyle(color: pDarkerRed),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: pRed, width: 2.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: screenSize.width / 1.5,
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: pDarkerRed),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: pRed, width: 2.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                      child: const Icon(Icons.image, size: 50),
                    ),
            ),
            const SizedBox(height: 20),
            IconButton(
              iconSize: 80,
              icon: Icon(Icons.file_upload_outlined, color: pDarkRed),
              onPressed: () async {
                await _pickImage(exercise);
                updateParentState(() {});
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    color: pDarkerRed,
                  ),
                  IconButton(
                    onPressed: () async {
                      exercise.name = exerciseController.text;
                      exercise.description = descriptionController.text;
                      if (exercise.id != null) {
                        await _firestore
                            .collection('exercises')
                            .doc(exercise.id)
                            .update({
                          'name': exercise.name,
                          'description': exercise.description,
                        });
                      }
                      updateParentState(() {});
                      Navigator.of(context).pop();
                    },
                    color: Colors.green,
                    icon: const Icon(Icons.check_circle),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: pDarkerRed),
                    onPressed: () async {
                      if (exercise.id != null) {
                        await _firestore
                            .collection('exercises')
                            .doc(exercise.id)
                            .delete();
                      }
                      updateParentState(() {});
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


void _addWorkout() async {
  // Consulta para encontrar o maior ID existente
  var snapshot = await _firestore.collection('workouts').get();
  int nextId = 1;

  if (snapshot.docs.isNotEmpty) {
    // Encontra o maior ID existente na coleção
    nextId = snapshot.docs
        .map((doc) => int.tryParse(doc.id) ?? 0) // Tenta converter os IDs para inteiros
        .reduce((curr, next) => curr > next ? curr : next) + 1;
  }

  // Cria o novo treino com o próximo ID como String
  var novoTreino = Workout(
    name: 'Novo Treino',
    userId: GlobalContext.userId!,
    id: nextId.toString(),
  );

  // Adiciona o novo treino ao Firestore
  await _firestore.collection('workouts').doc(novoTreino.id).set(novoTreino.toMap());
}
Future<void> _addExercise(String workoutId) async {
  var novoExercicio = Exercise(
    workoutId: workoutId,
    id: "teste",
    name: '',
    description: '',
  );

  await _firestore.collection('exercises').add(novoExercicio.toMap());
}

void _removeWorkout(String workoutId) async {
  await _firestore.collection('workouts').doc(workoutId).delete();
  
  var exercisesSnapshot = await _firestore
      .collection('exercises')
      .where('workoutId', isEqualTo: workoutId)
      .get();
  
  for (var doc in exercisesSnapshot.docs) {
    await doc.reference.delete();
  }
}

void _showWorkoutPopup(BuildContext context, Workout workout, int workoutIndex) {
  TextEditingController workoutController =
      TextEditingController(text: workout.name);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: TextField(
              controller: workoutController,
              decoration: const InputDecoration(labelText: 'Título do Treino'),
            ),
            content: SizedBox(
              height: 300,
              width: double.maxFinite,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('exercises')
                    .where('workoutId', isEqualTo: workout.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Erro ao carregar exercícios'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('Adicione exercícios ao seu treino'));
                  }

                  final exercises = snapshot.data!.docs
                      .map((doc) => Exercise.fromFirestore(doc))
                      .toList();

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
                          title: Text(exercise.name.isEmpty
                              ? 'Adicione um nome'
                              : exercise.name),
                          leading: exercise.image != null
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(exercise.image!),
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.image),
                                ),
                          onTap: () => _showEditDialog(exercise, setState),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    color: pDarkerRed,
                    icon: const Icon(Icons.close),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (workout.id != null) {
                        //await _addExercise(workout.id!);
await _addExercise("1");
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      shape: const CircleBorder(),
                      elevation: 8,
                      backgroundColor: pRed,
                    ),
                    child: Icon(Icons.add, size: 30, color: pWhite),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (workout.id != null) {
                        workout.name = workoutController.text;
                        await _firestore
                            .collection('workouts')
                            //.doc(workout.id)
                            .doc("oi")
                            .update({'name': workout.name});
                      }
                      Navigator.of(context).pop();
                    },
                    color: Colors.green,
                    icon: const Icon(Icons.check_circle),
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

  return SizedBox(
    width: screenSize.width / 1.5,
    height: screenSize.height / 1.5,
    child: Column(
      children: [
        ElevatedButton(
          onPressed: _onButtonPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              const SizedBox(width: 10),
              Text(buttonText, style: TextStyle(color: pWhite)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('workouts')
                .where('userId', isEqualTo: GlobalContext.userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Erro ao carregar treinos');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final workouts = snapshot.data?.docs
                  .map((doc) => Workout.fromFirestore(doc))
                  .toList() ?? [];

              return ListView.builder(
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
                        subtitle: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('exercises')
                              .where('workoutId', isEqualTo: workout.id)
                              .snapshots(),
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
                              final exerciseCount =
                                  snapshot.data?.docs.length ?? 0;
                              return Text(
                                '$exerciseCount exercícios',
                                style: TextStyle(color: pGray),
                              );
                            }
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: pDarkerRed),
                          //onPressed: () => _removeWorkout(workout.id!),
                          onPressed: () => _removeWorkout("oi"),
                        ),
                        onTap: () => _showWorkoutPopup(context, workout, index),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addWorkout,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15),
            shape: const CircleBorder(),
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
