import 'package:diary_app/DiaryApp/MainPage.dart';
import 'package:diary_app/DiaryApp/confirmEmail.dart';
import 'package:diary_app/DiaryApp/forgotPasswordPage.dart';
import 'package:diary_app/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';
class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  @override
  bool isSended = false;
  bool? isConfirmed = FirebaseAuth.instance.currentUser?.emailVerified;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text("Мой профиль"),
        ),
      ),
      body: isConfirmed! ? isConfirm() : isNotConfirm(),
    );
  }

  Widget isNotConfirm(){
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              confirmDialog();
            },
            leading: Icon(Icons.mark_email_read, color: Colors.grey),
            title: Text("Ваша почта не потверждена", style: TextStyle(color: Colors.grey),),
            subtitle: Text("Потвердите следуя указаниям", style: TextStyle(color: Colors.grey),),
          ),
          Divider(color: Colors.grey),
          ListTile(
            onTap:() async {
              await updateNameDialog();
              setState(() {
              });
            },
            leading: Icon(Icons.person, color: Colors.grey),
            title: Text("${FirebaseAuth.instance.currentUser?.displayName}", style: TextStyle(color: Colors.grey),),
            subtitle: Text("Нажмите для смены имени", style: TextStyle(color: Colors.grey),),
          ),
          Divider(color: Colors.grey),
          ListTile(
            onTap:() async {
              await updateEmailDialog();
              setState((){});
            },
            leading: Icon(Icons.mail, color: Colors.grey),
            title: Text("${FirebaseAuth.instance.currentUser?.email}", style: TextStyle(color: Colors.grey),),
            subtitle: Text("Нажмите для смены почты", style: TextStyle(color: Colors.grey),),
          ),
          Divider(color: Colors.grey),
          ListTile(
            onTap:() async {
              await changePassword();
              setState((){});
            },
            leading: Icon(Icons.lock, color: Colors.grey,),
            title: Text("Нажмите для смены пароля", style: TextStyle(color: Colors.grey),),
          ),
        ],
      ),
    );
  }


  isConfirm(){
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            ListTile(
              onTap:() async {
                await updateNameDialog();
                setState(() {
                });
            },
              leading: Icon(Icons.person, color: Colors.grey),
              title: Text("${FirebaseAuth.instance.currentUser?.displayName}", style: TextStyle(color: Colors.grey),),
              subtitle: Text("Нажмите для смены имени", style: TextStyle(color: Colors.grey),),
            ),
            Divider(color: Colors.grey),
            ListTile(onTap:() async {
              await updateEmailDialog();
              setState((){});
            },
              leading: Icon(Icons.mail, color: Colors.grey),
              title: Text("${FirebaseAuth.instance.currentUser?.email}", style: TextStyle(color: Colors.grey),),
              subtitle: Text("Нажмите для смены почты", style: TextStyle(color: Colors.grey),),
            ),
            Divider(color: Colors.grey),
            ListTile(
              onTap:() async {
                await changePassword();
                setState((){});
              },

            //   onTap: () {
            //   Navigator.of(context).push(
            //       MaterialPageRoute(builder: (context) => forgotPasswordPage())
            //   );
            // },
              leading: Icon(Icons.lock, color: Colors.grey,),
              title: Text("Нажмите для смены пароля", style: TextStyle(color: Colors.grey),),
            ),
            Divider(color: Colors.grey,),
            ListTile(
              leading: Icon(Icons.schedule, color: Colors.grey),
              title: Text("Напоминатель", style: TextStyle(color: Colors.grey)),
            )

          ],
        ),
      );
    }


  Future<void> confirmDialog() async{
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return
                isSended ?
                SimpleDialog(
                  title: Text(
                    'Далее для полной верификации требуется повторная авторизация. Сделать это сейчас?',
                    textAlign: TextAlign.center,),
                  children: <Widget>[Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              )
                          );
                        }, child: Text("Да", style: TextStyle(fontSize: 20),)),
                        ElevatedButton(onPressed: () {
                          Navigator.pop(context);
                        }, child: Text("Нет", style: TextStyle(fontSize: 20),)),
                      ],
                    ),
                  ),
                  ],
                )
                    :
                SimpleDialog(
                  title: Text('На почту ${FirebaseAuth.instance.currentUser
                      ?.email} будет отправлена ссылка с дальнейшими указаниями',
                    textAlign: TextAlign.center,),
                  children: <Widget>[
                    Center(
                      child: ElevatedButton(onPressed: () async {
                        await FirebaseAuth.instance.currentUser
                            ?.sendEmailVerification();
                        isSended = true;
                        setState(() {});
                      },
                          child: Text(
                            "Отправить", style: TextStyle(fontSize: 20),)),
                    ),
                  ],
                );
            });
          });
  }
  Future<void> updateNameDialog()async {
    TextEditingController newNameController = TextEditingController();
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Введите новое имя', textAlign: TextAlign.center,),
            children: <Widget>[Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(color: Colors.black),
                maxLines: 1,
                controller: newNameController,
                decoration: const InputDecoration(
                  iconColor: Colors.yellow,
                  fillColor: Colors.white30,
                  filled: true,
                  labelText: 'Имя',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: ElevatedButton(onPressed: () async{
                await FirebaseAuth.instance.currentUser?.updateDisplayName(newNameController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Имя успешно изменено')));
              }, child: Text("Сменить имя")),
            )],
          );
        }
    );
  }
  Future<void> updateEmailDialog()async {
    TextEditingController newEmailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Введите текущий пароль и новую почту', textAlign: TextAlign.center,),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  maxLines: 1,
                  controller: passwordController,
                  decoration: const InputDecoration(
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
                style: const TextStyle(color: Colors.black),
                maxLines: 1,
                controller: newEmailController,
                decoration: const InputDecoration(
                  iconColor: Colors.yellow,
                  fillColor: Colors.white30,
                  filled: true,
                  labelText: 'Новая почта',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
            ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: ElevatedButton(onPressed: () async{
                  String email = FirebaseAuth.instance.currentUser?.email as String;
                  FireAuth.reAuthUser(password: passwordController.text, email: email, context: context);
                  // await FirebaseAuth.instance.signInWithEmailAndPassword(email: "${FirebaseAuth.instance.currentUser?.email}", password: passwordController.text);
                  await FirebaseAuth.instance.currentUser?.updateEmail(newEmailController.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Почта успешно изменена')));
                }, child: Text("Сменить почту")),
              )],
          );
        }
    );
  }
  Future<void> changePassword() async{
    TextEditingController passwordController = TextEditingController();
    TextEditingController newPassword1 = TextEditingController();
    TextEditingController newPassword2 = TextEditingController();
    await showDialog(context: context, builder: (BuildContext context){
      return SimpleDialog(
        title: Text("Заполните все поля для смены пароля"),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              style: const TextStyle(color: Colors.black),
              maxLines: 1,
              controller: passwordController,
              decoration: const InputDecoration(
                iconColor: Colors.yellow,
                fillColor: Colors.white30,
                filled: true,
                labelText: 'Старый пароль',
                labelStyle: TextStyle(color: Colors.grey),
              )),
        ),
        SizedBox(height: 8,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: const TextStyle(color: Colors.black),
            maxLines: 1,
            controller: newPassword1,
            decoration: const InputDecoration(
            iconColor: Colors.yellow,
            fillColor: Colors.white30,
            filled: true,
            labelText: 'Пароль',
            labelStyle: TextStyle(color: Colors.grey),
          )),
        ),
        SizedBox(height: 8,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: const TextStyle(color: Colors.black),
            maxLines: 1,
            controller: newPassword2,
            decoration: const InputDecoration(
            iconColor: Colors.yellow,
            fillColor: Colors.white30,
            filled: true,
            labelText: 'Повторите пароль',
            labelStyle: TextStyle(color: Colors.grey),
          )),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: ElevatedButton(onPressed: ()async{
            if ((newPassword1.text == newPassword2.text) &&(newPassword2.text.length > 5)) {
              String email = FirebaseAuth.instance.currentUser?.email as String;
              FireAuth.reAuthUser(password: passwordController.text, email: email, context: context);
              await FirebaseAuth.instance.currentUser?.updatePassword(
                  newPassword2.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Пароль успешно изменен')));
            }
            else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Пароли не совпадают или подберите пароль по-длиннее')));
            }
            }, child: Text("Сменить пароль")),
        )
      ],);
    });
  }
  }

