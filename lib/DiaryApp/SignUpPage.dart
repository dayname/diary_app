import 'package:diary_app/DiaryApp/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/auth.dart';

class SignUpPage extends StatefulWidget {
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
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordFirstController = TextEditingController();
    TextEditingController passwordSecondController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Center(child: Text("Регистрация", style: const TextStyle(fontSize: 24,),)),
        ),),
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
              controller: passwordFirstController,
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
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 1,
              obscureText: true,
              style: TextStyle(color: Colors.grey),
              controller: passwordSecondController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.grey,),
                iconColor: Colors.yellow,
                fillColor: Colors.white30,
                filled: true,
                labelText: 'Повторите пароль',
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(onPressed: () async {
              if (passwordFirstController.text == passwordSecondController.text){
              if ((nameController.text != "") & (passwordFirstController.text != "") & (emailController.text != "")) {
                User? user = await FireAuth
                    .registerUsingEmailPassword(
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordFirstController.text,
                  context: context,
                );
                setState(() {
                });
                if (user != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(user: user),),);
                }
              }
              else {
                ifNotFul();
              }
              }
              else {
                ifNotMatch();
              }
            },

              child: Text("Зарегистрироваться".toUpperCase(),
                style: TextStyle(fontSize: 20,),),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(
                      right: 55, left: 55, top: 15, bottom: 13)
              ),
            ),
          ),
        ],
      ),
    );
  }



  Future<void> ifNotFul() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Заполните все поля'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Хорошо'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> ifNotMatch() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Пароли не совпадают'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Хорошо'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Future <void> sendData()async {
  //   await FirebaseFirestore.instance.collection("UserData")
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .set({"email": FirebaseAuth.instance.currentUser?.email, "name" : FirebaseAuth.instance.currentUser?.displayName});
  // }
}