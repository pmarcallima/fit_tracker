
import 'dart:io';

import 'package:fit_tracker/pages/tabs/friendList.dart';
import 'package:fit_tracker/pages/tabs/friendProfile.dart';
import 'package:fit_tracker/pages/tabs/home.dart';
import 'package:fit_tracker/pages/tabs/login.dart';
import 'package:fit_tracker/pages/tabs/register.dart';
import 'package:fit_tracker/pages/tabs/teste.dart';
import 'package:fit_tracker/pages/tabs/workouts.dart';
import 'package:fit_tracker/pages/tabs/personalData.dart';
import 'package:fit_tracker/pages/tabs/aboutUs.dart';
import 'package:fit_tracker/widgets/features/friend_list.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:fit_tracker/widgets/features/friend_data.dart';
import 'utils/colors.dart';

Future<void> main() async {
  // Initialize FFI
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => HomePage(title: 'Fit Tracker'),
        '/register': (BuildContext context) => RegisterPage(),
        '/workouts': (BuildContext context) => WorkoutsPage(),
        '/personalData': (BuildContext context) => PersonalDataPage(),
        '/friendList': (BuildContext context) => FriendsListPageWrapper(),
        '/aboutUs': (BuildContext context) => AboutUsPage(),
        '/friendData': (BuildContext context) => FriendDataPage(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEEE6E7),
        useMaterial3: true,
      ),
      home: HomePage(title: 'Fit Tracker'),
    );
  }
}
