
import 'package:flutter/material.dart';
import 'package:fit_tracker/services/providers/database_helper.dart';
import 'package:fit_tracker/services/models/statistics.dart';
import 'package:fit_tracker/services/models/workout.dart';
import 'package:fit_tracker/services/models/exercise.dart';
import 'package:fit_tracker/services/models/user.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    _users = await _databaseHelper.getAllUsers();
    for (var user in _users) {
      // Usar um valor padrão caso birthDate seja null
      int birthDateMilliseconds = user.birthDate ?? 0; // Se for null, assume 0
      print('User: ${user.email}, Name: ${user.firstName} ${user.lastName}, Birth Date: ${DateTime.fromMillisecondsSinceEpoch(birthDateMilliseconds)}');
    }
    setState(() {});
  }

  Future<void> _addUser() async {
    User user = User(
      email: _emailController.text,
      password: _passwordController.text,
      firstName: "First",
      lastName: "Last",
      birthDate: DateTime.now().millisecondsSinceEpoch, // Exemplo de data em milissegundos
    );
    
    await _databaseHelper.insertUser(user);
    _emailController.clear();
    _passwordController.clear();
    _fetchUsers(); // Recarregar a lista de usuários
  }

  Future<void> _listAllUsers() async {
    await _fetchUsers(); // Chama o método que busca os usuários e atualiza a lista
    // Você pode adicionar lógica adicional aqui se precisar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _addUser,
              child: Text('Add User'),
            ),
            ElevatedButton(
              onPressed: _listAllUsers,
              child: Text('List All Users'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_users[index].email),
                    subtitle: Text('${_users[index].firstName} ${_users[index].lastName}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
