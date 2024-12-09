
import 'dart:typed_data';

class User {
  String? id;
  String email;
  String? firstName;
  String? lastName;
  String password;
  DateTime? birthDate;
  Uint8List? profilePicture;

  User({
    this.id,
    required this.email,
    required this.password,
    this.birthDate,
    this.firstName,
    this.lastName,
    this.profilePicture,
  });

  // Método para criar um objeto User a partir de um Map
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['uid'], // Aqui assumimos que o campo de ID no Firestore é 'uid'
      email: data['email'],
      firstName: data['firstName'],  // Mapeando 'firstName'
      lastName: data['lastName'],    // Mapeando 'lastName'
      password: data['password'],
      birthDate: data['birthDate'] != null ? DateTime.fromMillisecondsSinceEpoch(data['birthDate']) : null, // Convertendo timestamp para DateTime
      profilePicture: data['profilePicture'], // Caso o profilePicture seja um Uint8List armazenado
    );
  }

  // Método para converter o objeto User de volta para um Map
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'birthDate': birthDate?.millisecondsSinceEpoch, // Convertendo DateTime para timestamp
      'profilePicture': profilePicture,
    };
  }
}
