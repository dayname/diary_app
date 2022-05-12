import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  late String name;
  late String email;
  late int counterOfStory;
  late List<String> hints;
  late dynamic hour;
  late dynamic minute;

  UserData.fromDoc(DocumentSnapshot doc) {
    name = doc["name"];
    email = doc["email"];
    counterOfStory = doc["counterOfStory"];
    hints = doc["hints"].cast<String>();
    hour = doc["hour"];
    minute = doc['minute'];
  }
}