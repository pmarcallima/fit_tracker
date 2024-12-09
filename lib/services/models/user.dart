
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

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['uid'], 
      email: data['email'],
      firstName: data['name'],  
      lastName: data['surname'],    
      password: data['password'],
      birthDate: data['birthDate'] != null ? DateTime.fromMillisecondsSinceEpoch(data['birthDate']) : null, 
      profilePicture: data['profilePicture'], 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'email': email,
      'name': firstName,
      'surname': lastName,
      'password': password,
      'birthDate': birthDate?.millisecondsSinceEpoch, 
      'profilePicture': profilePicture,
    };
  }
}
