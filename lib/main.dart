import 'dart:io';

import 'package:diary_app/DiaryApp/LoginPage.dart';
import 'package:diary_app/DiaryApp/MainPage.dart';
import 'package:diary_app/utils/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;


main() async {
  tz.initializeTimeZones();
  runApp(MyApp());
}
// class DateStorage {
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//
//     return directory.path;
//   }
//
//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/Date.txt');
//   }
//
//   Future<DateTime> readDateTime() async {
//     try {
//       final file = await _localFile;
//
//       // Read the file
//       final contents = await file.readAsString();
//
//       return DateTime.parse(contents);
//     } catch (e) {
//       // If encountering an error, return 0
//       return DateTime.now();
//     }
//   }
//
//   Future<File> writeDateTime(DateTime Time) async {
//     final file = await _localFile;
//
//     // Write the file
//     return file.writeAsString('$Time');
//   }
// }


class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'Rostov',
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.yellow,
            accentColor: Colors.yellowAccent,
          )),
      home: LoginPage(),
    );
  }



}
