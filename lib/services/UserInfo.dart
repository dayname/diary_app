import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  late String name;
  late String email;

  UserData.fromDoc(DocumentSnapshot doc) {
    name = doc["name"];
    email = doc["email"];
  }
}