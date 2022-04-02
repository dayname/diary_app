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

  Future<AuthUser?> registerWithEmailAndPassword(String email, String password, String name) async {
    try{
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      user?.updateDisplayName(name);
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