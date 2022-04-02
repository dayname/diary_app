import 'package:diary_app/DiaryApp/LoginSignupPage.dart';
import 'package:diary_app/domain/authuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';


class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static PageRouteBuilder getRoute() {
    return PageRouteBuilder(
        transitionsBuilder: (_, animation, secondAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        }, pageBuilder: (_, __, ___) {
      return new SignUpPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController =    TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController =     TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text("Регистрация", style: const TextStyle(fontSize: 20,),),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: Colors.grey),
              maxLines: 1,
              controller: nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person, color: Colors.grey,),
                iconColor: Colors.yellow,
                fillColor: Colors.white30,
                filled: true,
                labelText: 'Имя',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: Colors.grey),
              maxLines: 1,
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail, color: Colors.grey,),
                iconColor: Colors.yellow,
                fillColor: Colors.white30,
                filled: true,
                labelText: 'Почта',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 1,
              obscureText: true,
              style: TextStyle(color: Colors.grey),
              controller: passwordController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.grey,),
                iconColor: Colors.yellow,
                fillColor: Colors.white30,
                filled: true,
                labelText: 'Пароль',
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(onPressed: () {
              toRegister(email: emailController.text, password: passwordController.text, name: nameController.text);
              Navigator.pop(context);
            }, child: Text("Зарегистрироваться".toUpperCase(), style: TextStyle(fontSize: 20,),),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(right: 55,left: 55, top: 15, bottom: 13)
              ),
            ),
          ),
        ],
      ),
    );
  }

  toRegister({required String email, required String password, required String name}) async{
    await AuthService().registerWithEmailAndPassword(email, password, name);
  }
}
