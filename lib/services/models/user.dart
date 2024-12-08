import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
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
		this.profilePicture

	});
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String?,
      email: map['email'] as String,
      password: map['password'] as String,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
      birthDate: map['birthDate'] as DateTime?,
      profilePicture: map['profilePicture'] != null 
          ? Uint8List.fromList(List<int>.from(map['profilePicture'])) 
          : null,
    );
  }

	Map<String, dynamic> toMap ()
{
		return {
			'id' : id,
			'email': email,
			'firstName' : firstName,
			'lastName' : lastName,
			'password' : password,
			'birthDate' : birthDate,
			'profilePicture' : profilePicture,
		};
	}

}
