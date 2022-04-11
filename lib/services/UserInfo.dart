import 'package:firebase_auth/firebase_auth.dart';

class userInfo{
  String? name;
  String? email;
  String? user_id;

  userInfo.getInfo(){
    name = FirebaseAuth.instance.currentUser?.displayName;
    email = FirebaseAuth.instance.currentUser?.email;
    user_id = FirebaseAuth.instance.currentUser?.uid;

  }
}