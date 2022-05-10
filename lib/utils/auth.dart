import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class FireAuth {
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      FirebaseFirestore.instance.collection("UsersData")
          .doc("${FirebaseAuth.instance.currentUser?.uid}")
          .set({
        "name": auth.currentUser?.displayName,
        "email": auth.currentUser?.email,
        "counterOfStory": 0,
        "hints": ["ААААААААААААААААААААААААА", "ббббббббббббббббббббб", "сссссссссссссссссссссссссс", "ddddddddddddddddddd", "eeeeeeeeeeeeeeeeeee", "fffffffffffffffffffffff", "ggggggggggggggggggggg", "выыыыыыывывывывывыыыввыы", "trrtertwetjwlrjlwejtlwre"]
      });
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Пароль должен иметь не менее 6 символов.')));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Данная почта уже зарегистрирована.')));
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }


  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Данная почта еще не зарегистрирована.')));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Неправильный пароль.')));
        print('Wrong password provided.');
      }
    }
  }

  static Future<User?> logOut() async{
    await FirebaseAuth.instance.signOut();
  }
  static resetPassword(String email, BuildContext context) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: email);
  }

  static Future<User?> reAuthUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Данная почта еще не зарегистрирована.')));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Неправильный пароль.')));
        print('Wrong password provided.');
      }
    }
  }
  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }
}