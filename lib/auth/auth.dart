
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveUserDetails(String uid, String firstName, String lastName, int birthDate) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
    });
    print('Detalhes do usuário salvos no Firestore.');
  } catch (e) {
    print('Erro ao salvar detalhes do usuário no Firestore: $e');
  }
}

Future<void> registerUser(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    print('Usuário registrado: ${userCredential.user?.email}');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('A senha fornecida é muito fraca.');
    } else if (e.code == 'email-already-in-use') {
      print('Este email já está registrado.');
    }
  } catch (e) {
    print('Erro: $e');
  }
}
