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
  TextEditingController emailController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text("Восстановление пароля"),
      ),),
      body: forgotPasswordView(),
    );
  }
  forgotPasswordView(){
    return Column(mainAxisAlignment: MainAxisAlignment.center,
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
        ElevatedButton(onPressed: () async{
          FireAuth.resetPassword(emailController.text, context);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Ссылка для восстановления пароля отправлена на почту")));
        }, child: Text("Сбросить пароль", style: TextStyle(fontSize: 20),))
      ],
    );
  }
}
