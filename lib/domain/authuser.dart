import 'package:firebase_auth/firebase_auth.dart';

class AuthUser{
  String? id;
  String? name;

  AuthUser.fromFirebase(User? user){
    id = user!.uid;
    name = FirebaseAuth.instance.currentUser?.displayName;
  }
}