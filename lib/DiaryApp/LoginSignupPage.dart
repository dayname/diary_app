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
      );}

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
              toLogin(email: emailController.text, password: passwordController.text);
            }, child: Text("ВОЙТИ", style: TextStyle(fontSize: 20),),
              style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 130, vertical: 15 )
            ),),
          ),
          InkWell(onTap: () {
              Navigator.push(context, SignUpPage.getRoute());
          },child: Center(child: Text("Еще не зарегистрированы? Регистрируйтесь!", style: TextStyle(color: Colors.grey),))),
        ],
      );
  }

  toLogin({required String email, required String password}) async {
    AuthUser? authService = await AuthService().signInWithEmailAndPassword(email, password);
  }

}

