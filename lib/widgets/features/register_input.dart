import 'package:fit_tracker/services/providers/firebase_helper.dart';
import 'package:fit_tracker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fit_tracker/services/models/user.dart' as model;
import 'package:fit_tracker/services/providers/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:fit_tracker/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
class RegisterInput extends StatefulWidget {
  @override
  _RegisterInputState createState() => _RegisterInputState();
}

class _RegisterInputState extends State<RegisterInput> {

  final FirebaseService _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _selectedDate;


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
  Future<void> _addUser() async {
if (_formKey.currentState!.validate()) {
  if (_selectedDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor, selecione uma data de nascimento')),
    );
    return;
  }

  try {
    final auth.UserCredential userCredential = await auth.FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (userCredential.user != null) {
      final userData = {
        'uid': userCredential.user!.uid,
        'name': _nameController.text,
        'surname': _surnameController.text,
        'birthdate': _selectedDate!.millisecondsSinceEpoch,
        'email': _emailController.text.trim(),
      };
      _firebaseService.createUserStatistics(userCredential.user!.uid);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData);

      _nameController.clear();
      _surnameController.clear();
      _birthdateController.clear();
      _emailController.clear();
      _passwordController.clear();
      setState(() {
        _selectedDate = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário registrado com sucesso!')),
      );

      Navigator.pushNamed(context, '/home');
    }
  } on auth.FirebaseAuthException catch (e) {
    String errorMessage;
    switch (e.code) {
      case 'weak-password':
        errorMessage = 'A senha fornecida é muito fraca.';
        break;
      case 'email-already-in-use':
        errorMessage = 'Este email já está registrado.';
        break;
      case 'invalid-email':
        errorMessage = 'O email fornecido é inválido.';
        break;
      default:
        errorMessage = 'Ocorreu um erro no registro: ${e.message}';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  } catch (e) {
    print('Erro durante o registro: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao registrar usuário: $e')),
    );
  }
}
}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    iconColor: Color(0xffEEEEEE),
                    fillColor: pWhite,
                    filled: true,
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Por favor, digite seu nome';
                    return null;
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    iconColor: Color(0xffEEEEEE),
                    fillColor: pWhite,
                    filled: true,
                    labelText: 'Sobrenome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Por favor, digite seu sobrenome';
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: _birthdateController,
            decoration: InputDecoration(
              iconColor: Color(0xffEEEEEE),
              fillColor: pWhite,
              filled: true,
              labelText: 'Data de Nascimento',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Por favor, selecione sua data de nascimento';
              return null;
            },
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              iconColor: Color(0xffEEEEEE),
              fillColor: pWhite,
              filled: true,
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Por favor, digite seu email';
              if (!value.contains('@'))
                return 'Por favor, digite um email válido';
              return null;
            },
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              iconColor: Color(0xffDC5F00),
              fillColor: pWhite,
              filled: true,
              labelText: 'Senha',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Por favor, digite sua senha';
              if (value.length < 6)
                return 'A senha deve ter pelo menos 6 caracteres';
              return null;
            },
          ),
          SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: ElevatedButton(
              onPressed: _addUser,
              child: Text('Cadastrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: pRed,
                foregroundColor: pWhite,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _birthdateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
