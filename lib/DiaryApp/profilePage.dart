
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/utils/UserInfo.dart';
import 'package:diary_app/utils/auth.dart';
import 'package:diary_app/utils/notifications.dart';
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
  // void initState() {
  //   super.initState();
  //
  //   setState(() {
  //     getUserInfo().whenComplete(() => null);
  //   });
  // }
  var hour;
  var minute;
  UserData? userData;
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
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                title: Text("Аккаунт", style: TextStyle(color: Colors.grey, fontSize: 23),),
              ),
            ),
            ListTile(
              onTap: () {
                confirmDialog();
              },
              leading: Icon(Icons.mark_email_read, color: Colors.grey),
              title: Text("Ваша почта не потверждена", style: TextStyle(color: Colors.grey),),
              subtitle: Text("Потвердите следуя указаниям", style: TextStyle(color: Colors.grey),),
            ),
            Divider(color: Colors.grey,),

            ListTile(
              onTap:() async {
                await updateNameDialog();
                setState(() {});
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

              leading: Icon(Icons.lock, color: Colors.grey,),
              title: Text("Нажмите для смены пароля", style: TextStyle(color: Colors.grey),),
            ),
            Divider(color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: ListTile(
                title: Text("Уведомление", style: TextStyle(color: Colors.grey, fontSize: 23),),
              ),
            ),
            Divider(color: Colors.grey,),
            ListTile(
              onTap: () async{
                var Time;
                await showTimePicker(context: context,
                  initialTime: TimeOfDay.now(),
                  helpText: "Выберите время",
                ).then((selectedTime) async {
                  var tempHour = selectedTime!.hour;
                  var tempMinute = selectedTime.minute;

                  print("Before: $tempHour:$tempMinute");
                  if (tempMinute < 10 && tempHour < 10) {
                    hour = "0${tempHour}";
                    minute = "0${tempMinute}";
                  }
                  else if (tempMinute < 10){
                    hour = tempHour;
                    minute = "0${tempMinute}";

                    // else {
                    //   hour = tempHour;
                    //   minute = "00${tempMinute}";
                    // }
                  } else if (tempHour < 10){
                    hour = "0${tempHour}";
                    minute = tempMinute;
                  } else {
                    hour = tempHour;
                    minute = tempMinute;
                  }
                  print("After: $hour:$minute");
                  var year = DateTime.now().year;
                  var month = DateTime.now().month;
                  var day = DateTime.now().day;
                  print(DateTime.now());
                  if (month < 10) {
                    Time = DateTime.parse("$year-0$month-$day $hour:$minute:00.000000");
                  } else if (day < 10) {
                    Time = DateTime.parse("$year-$month-0$day $hour:$minute:00.000000");
                  } else if (day < 10 && month < 10) {
                    Time = DateTime.parse("$year-0$month-0$day $hour:$minute:00.000000");
                  }
                  List<String> titleCollection = ["👋Привет, ${FirebaseAuth.instance.currentUser?.displayName}!", "Как дела, ${FirebaseAuth.instance.currentUser?.displayName}?"];
                  List<String> bodyCollection = ["Время вести дневник⌚", "Напиши о том, как прошел день", "Не знаешь о чем писать? Воспользуйся подсказками!", "Поделись впечатлениями о сегодняшнем дне"];
                  //2022-05-11 21:15:40.622207
                  int title = Random().nextInt(titleCollection.length);
                  int body = Random().nextInt(bodyCollection.length);
                  timeUpdate(hour, minute);
                  print(Time);
                  NotificationApi.showNotificationDaily(
                    title: titleCollection[title],
                    body: bodyCollection[body],
                    schedule: Time,
                    payload: 'diaryapp',
                  );
                }
                );
                setState(() {});
              },
              title: hour == null ? Text("Настройте напоминатель", style: TextStyle(color: Colors.grey)) : Text("Время показа - ${hour}:${minute}", style: TextStyle(color: Colors.grey)),
              leading: Icon(Icons.schedule, color: Colors.grey,),
            ),
            Divider(color: Colors.grey,),
            ListTile(
              onTap: ()async {
                await NotificationApi.cancelNotification();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Уведомления отключены')));
              },
              title: Text("Отключить уведомления", style: TextStyle(color: Colors.grey),),
              leading: Icon(Icons.cancel_outlined, color: Colors.grey,),
            ),
            Divider(color: Colors.grey,),
            ListTile(
              onTap: () async{
                await _askedToLogOut();
              },
              leading: Icon(Icons.logout, color: Colors.grey),
              title: Text("Выйти из аккаунта", style: TextStyle(color: Colors.grey)),
            )
          ],
        ),
      ),
    );
  }


  isConfirm(){
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: ListTile(
                  title: Text("Аккаунт", style: TextStyle(color: Colors.grey, fontSize: 23),),
                ),
              ),
              Divider(color: Colors.grey,),

              ListTile(
                onTap:() async {
                  await updateNameDialog();
                  setState(() {});
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

                leading: Icon(Icons.lock, color: Colors.grey,),
                title: Text("Нажмите для смены пароля", style: TextStyle(color: Colors.grey),),
              ),
              Divider(color: Colors.grey,),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: ListTile(
                  title: Text("Уведомление", style: TextStyle(color: Colors.grey, fontSize: 23),),
                ),
              ),
              Divider(color: Colors.grey,),
              ListTile(
                onTap: () async{
                  var Time;
                  await showTimePicker(context: context,
                    initialTime: TimeOfDay.now(),
                    helpText: "Выберите время",
                  ).then((selectedTime) async {
                    var tempHour = selectedTime!.hour;
                    var tempMinute = selectedTime.minute;

                    print("Before: $tempHour:$tempMinute");
                    if (tempMinute < 10 && tempHour < 10) {
                      hour = "0${tempHour}";
                      minute = "0${tempMinute}";
                    }
                     else if (tempMinute < 10){
                      hour = tempHour;
                      minute = "0${tempMinute}";

                      // else {
                      //   hour = tempHour;
                      //   minute = "00${tempMinute}";
                      // }
                  } else if (tempHour < 10){
                      hour = "0${tempHour}";
                      minute = tempMinute;
                    } else {
                      hour = tempHour;
                      minute = tempMinute;
                    }
                    print("After: $hour:$minute");
                    var year = DateTime.now().year;
                    var month = DateTime.now().month;
                    var day = DateTime.now().day;
                    print(DateTime.now());
                    if (month < 10) {
                      Time = DateTime.parse("$year-0$month-$day $hour:$minute:00.000000");
                    } else if (day < 10) {
                      Time = DateTime.parse("$year-$month-0$day $hour:$minute:00.000000");
                    } else if (day < 10 && month < 10) {
                      Time = DateTime.parse("$year-0$month-0$day $hour:$minute:00.000000");
                    }
                    List<String> titleCollection = ["👋Привет, ${FirebaseAuth.instance.currentUser?.displayName}!", "Как дела, ${FirebaseAuth.instance.currentUser?.displayName}?"];
                    List<String> bodyCollection = ["Время вести дневник⌚", "Напиши о том, как прошел день", "Не знаешь о чем писать? Воспользуйся подсказками!", "Поделись впечатлениями о сегодняшнем дне"];
                    //2022-05-11 21:15:40.622207
                    int title = Random().nextInt(titleCollection.length);
                    int body = Random().nextInt(bodyCollection.length);
                    timeUpdate(hour, minute);
                    print(Time);
                    NotificationApi.showNotificationDaily(
                      title: titleCollection[title],
                      body: bodyCollection[body],
                      schedule: Time,
                      payload: 'diaryapp',
                    );
                  }
                  );
                setState(() {});
                },
                title: hour == null ? Text("Настройте напоминатель", style: TextStyle(color: Colors.grey)) : Text("Время показа - ${hour}:${minute}", style: TextStyle(color: Colors.grey)),
                leading: Icon(Icons.schedule, color: Colors.grey,),
              ),
              Divider(color: Colors.grey,),
              ListTile(
                onTap: ()async {
                  await NotificationApi.cancelNotification();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Уведомления отключены')));
                },
                title: Text("Отключить уведомления", style: TextStyle(color: Colors.grey),),
                leading: Icon(Icons.cancel_outlined, color: Colors.grey,),
              ),
              Divider(color: Colors.grey,),
              ListTile(
                onTap: () async{
                await _askedToLogOut();
                },
                leading: Icon(Icons.logout, color: Colors.grey),
                title: Text("Выйти из аккаунта", style: TextStyle(color: Colors.grey)),
              )
            ],
          ),
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
  Future<void> getUserInfo() async {
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      userData = UserData.fromDoc(documentSnapshot);
    });
  }

  void timeUpdate(dynamic hour, dynamic minute)async{
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .update({"hour": hour, "minute": minute});

  }
  Future<void> _askedToLogOut() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Вы действительно хотите выйти из аккаунта?', textAlign: TextAlign.center,),
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
                  ElevatedButton(onPressed: () {Navigator.pop(context);}, child: Text("Нет", style: TextStyle(fontSize: 20),)),
                ],
              ),
            ),
            ],
          );
        }
    );
  }

  }

