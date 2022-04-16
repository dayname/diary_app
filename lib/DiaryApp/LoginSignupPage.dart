import 'package:diary_app/DiaryApp/SignUpPage.dart';
import 'package:diary_app/domain/authuser.dart';
import 'package:diary_app/services/auth.dart';
import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  // static getRoute(BuildContext context) {
  //   return PageRouteBuilder(
  //       transitionsBuilder: (_, animation, secondAnimation, child) {
  //         return FadeTransition(opacity: animation,
  //           child: child,);
  //       },
  //       pageBuilder: (_, __, ___) {
  //         return new LoginSignupPage();
  //       });
  // }

  const LoginSignupPage({Key? key}) : super(key: key);

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  @override
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "Diary App".toUpperCase(),
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            )),
      ),
      body: LoginScreen(),
    );
  }

  Column LoginScreen() {
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
            onPressed: () {
              if ((passwordController.text != "") & (emailController.text != "")){
              var result = toLogin(
                  email: emailController.text,
                  password: passwordController.text);
              }
              else {
                _ifNotFull();
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
                  Navigator.push(context, SignUpPage.getRoute());
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

  toLogin({required String email, required String password}) async {
    AuthUser? authService = await AuthService().signInWithEmailAndPassword(email, password);
    if (authService?.id == null){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Неправильная почта или пароль')));
    }
  }

  Future<void> _ifNotFull() async {
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
