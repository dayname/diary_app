import 'package:diary_app/DiaryApp/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';
import 'SignUpPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 6, left: 110),
            child: Text("Diary App".toUpperCase(),
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
          )
      ),
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}', style: TextStyle(color: Colors.white),));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return loginWidgets();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  loginWidgets(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(color: Colors.grey),
            maxLines: 1,
            controller: emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.mail,
                color: Colors.grey,
              ),
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
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.grey,
              ),
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
          child: ElevatedButton(
            onPressed: () async {
              if ((passwordController.text != "") & (emailController.text != "")){
                User? user = await FireAuth.signInUsingEmailPassword(
                  email: emailController.text,
                  password: passwordController.text);
                setState(() {});
                if (user != null) {
                  Navigator.of(context)
                      .pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage(user: user),
                      ),
                  );
                }
              }
              else{
                ifNotFul();
              }
              },
            child: Text(
              "ВОЙТИ",
              style: TextStyle(fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 130, vertical: 15)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Еще не зарегистрированы?",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            SizedBox(
              width: 8,
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text(
                  "Регистрируйтесь!",
                  style: TextStyle(color: Colors.yellow, fontSize: 15),
                )),
          ],
        ),
      ],
    );
  }


  Future<void> ifNotFul() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
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
}