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
          if (emailController.text != '') {
            FireAuth.resetPassword(emailController.text, context);
            isClicked = true;
            setState(() {

            });
          }
          else {
            ifNotFul();
          }
        }, child: const Text("Сбросить пароль", style: TextStyle(fontSize: 20),))
      ],
    );
  }
  clicked(){
    return Center(
        child: Text(
          "Ссылка для смены пароля отправлена на ${emailController.text}", style: TextStyle(fontSize: 23, color: Colors.yellow.withOpacity(0.5)), textAlign: TextAlign.center,)
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


