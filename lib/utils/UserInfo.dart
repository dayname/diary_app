import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  late String name;
  late String email;
  late int counterOfStory;

  UserData.fromDoc(DocumentSnapshot doc) {
    name = doc["name"];
    email = doc["email"];
    counterOfStory = doc["counterOfStory"];
  }
}