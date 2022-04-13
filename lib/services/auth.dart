import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/authuser.dart';

class AuthService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AuthUser?> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return AuthUser.fromFirebase(user);
    } on FirebaseException catch (error) {
      return null;
    }
  }

 registerWithEmailAndPassword(String email, String password, String name) async{
    try{
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      user?.updateDisplayName(name).then((value) {
        FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
            .set({
          "name": _firebaseAuth.currentUser?.displayName,
          "email": _firebaseAuth.currentUser?.email,
        });
      });
      return AuthUser.fromFirebase(user);
    }on FirebaseException catch(error){
      return null;
    }
  }
  Future logOut() async{
    await _firebaseAuth.signOut();
  }
  setName(String name){
    String? name;
  }
  Stream<AuthUser?> get currentUser{
    return _firebaseAuth.authStateChanges().map((User? user) => user != null ? AuthUser.fromFirebase(user) : null);
  }
}