import 'package:diary_app/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class forgotPasswordPage extends StatefulWidget {
  const forgotPasswordPage({Key? key}) : super(key: key);
  @override
  State<forgotPasswordPage> createState() => _forgotPasswordPageState();
}

class _forgotPasswordPageState extends State<forgotPasswordPage> {
  @override
  bool isClicked = false;
  TextEditingController emailController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text("Смена пароля"),
      ),),
      body: isClicked ? clicked() :forgotPasswordView(),
    );
  }
  forgotPasswordView(){
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: const TextStyle(color: Colors.grey),
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
        ElevatedButton(onPressed: () async{
          FireAuth.resetPassword(emailController.text, context);
          isClicked = true;
          setState(() {

          });
        }, child: const Text("Сбросить пароль", style: TextStyle(fontSize: 20),))
      ],
    );
  }
  clicked(){
    return Center(
        child: Text(
          "Ссылка для смены пароля отправлена на ${FirebaseAuth.instance
              .currentUser?.email}", style: TextStyle(fontSize: 23, color: Colors.yellow.withOpacity(0.5)), textAlign: TextAlign.center,)
    );
  }
}
