import 'package:diary_app/DiaryApp/LoginSignupPage.dart';
import 'package:diary_app/DiaryApp/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => print(value.options.projectId));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'Rostov',
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.yellow,
            accentColor: Colors.yellowAccent,
          )),
      home: MyAuth(),
    );
  }
}


class MyAuth extends StatefulWidget {
  MyAuth({Key? key}) : super(key: key);
  @override
  State<MyAuth> createState() => _MyAuthState();
}

class _MyAuthState extends State<MyAuth> {

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() => isLogged = user != null);
    });
    super.initState();
    setState(() {});
  }

  // void onStart() {
  //   checker();
  //   super.initState();
  //   setState(() {
  //
  //   });
  // }
  bool isLogged = false;
    Widget build(BuildContext context) {
      return Scaffold(
        body: isLogged ? MyHomePage() : LoginSignupPage(),
      );
    }

  void checker() async {
    if (await FirebaseAuth.instance.currentUser?.uid != null) {
      isLogged = true;
    }
  }


  // checker() {
  //   FirebaseAuth.instance
  //       .userChanges()
  //       .listen((User? user) {
  //     if (user != null) {
  //       isLogged != isLogged;
  //       setState(() {
  //
  //       });
  //     }
  //   });
  }
  // checker() async {
  //   await FirebaseAuth.instance.userChanges().listen((User? user) => user != null ? MyHomePage() : LoginSignupPage());
  // }

