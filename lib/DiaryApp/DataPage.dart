import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/utils/UserInfo.dart';
import 'package:diary_app/utils/data.dart';
import 'package:diary_app/utils/hints.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';


class InputNotes extends StatefulWidget {
  static getRoute(BuildContext context) {
    return PageRouteBuilder(
        transitionsBuilder: (_, animation, secondAnimation, child) {
          return FadeTransition(opacity: animation,
            child: child,);
        },
        pageBuilder: (_, __, ___) {
          return new InputNotes();
        });
  }

  @override
  State<InputNotes> createState() => _InputNotesState();
}

class _InputNotesState extends State<InputNotes> {
  late UserData userData;
  late String hint1;
  late String hint2;
  late String hint3;

  Map<int, dynamic> toDelete = {};

  bool isChoose1 = false;
  bool isChoose2 = false;
  bool isChoose3 = false;

  var date;
  var newDate;
  String? formattedDate;
  @override

  bool isDate = false;
  Widget build(BuildContext context) {
    TextEditingController textController = isChoose1 ? TextEditingController(text: hint1) : isChoose2 ? TextEditingController(text: hint2) : isChoose3 ? TextEditingController(text: hint3) : TextEditingController();
    TextEditingController titleController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {_askedToLeavePage();}, ),
          title: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: const EdgeInsets.only(top: 6),
                child: const Text("Введите историю"),
              ),
              IconButton(onPressed: () async{
                await getUserInfo();
                List<String> hints = userData.hints;
                if (hints.isNotEmpty)
                await chooseHint3(hints);
                else
                  ifEmpty();
                setState(() {});
              }, icon: const Padding(
                padding: EdgeInsets.only(top: 6, right: 10),
                child: Icon(Icons.tips_and_updates_outlined),
              ))
            ],
          ),
        ),

        body: Container(
          padding: const EdgeInsets.all(16),
            child: Column(children: [
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: Colors.grey),
                maxLines: 1,
                controller: titleController,
                decoration: const InputDecoration(
                  iconColor: Colors.yellow,
                  fillColor: Colors.white30,
                  prefixIcon: Icon(Icons.book, color: Colors.grey,),
                  filled: true,
                  labelText: 'Название',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16,),
              TextField(
                maxLines: 8,
                style: const TextStyle(color: Colors.grey),
                controller: textController,
                decoration: const InputDecoration(
                  iconColor: Colors.yellow,
                  fillColor: Colors.white30,
                  prefixIcon: Icon(Icons.notes, color: Colors.grey,),
                  filled: true,
                  labelText: 'Содержимое',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16,),
              Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showCalendar(context);
                    },
                    child: isDate ? Text("$formattedDate") : const Icon(Icons.date_range, color: Colors.black,),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                       if((textController.text != "") & (titleController.text != ""))
                       {counterUpdate();
                       await addStory(text: textController.text, title: titleController.text);
                       if (toDelete != null){
                         List<String> hints = toDelete[1];
                         List<int> idList = toDelete[2];
                         if (isChoose1 == true){hints.removeAt(idList.elementAt(0));
                         updateHints(hints);}
                         else if (isChoose2 == true){hints.removeAt(idList.elementAt(1));
                         updateHints(hints);}
                         else if (isChoose3 == true){hints.removeAt(idList.elementAt(2));
                         updateHints(hints);}}
                       Navigator.pop(context);}
                       else {
                         _ifNotFull();
                       }
                    },
                    child: Text("Сохранить".toUpperCase()),
                  ),
                ]
              ),
            ],
            )
        )
    );
  }

  Future<void> getUserInfo() async {
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
        userData = UserData.fromDoc(documentSnapshot);
    });
  }
  void counterUpdate()async{
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .update({"counterOfStory": FieldValue.increment(1)});

  }
  Future<void> addStory({required String text, required String title})
  async {
    await getUserInfo();
    int counter = userData.counterOfStory;
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("UserStories")
        .doc()
        .set({"title": title, "text": text, "date" : formattedDate, "counterOfStory" : counter});
 }

  Future _showCalendar(BuildContext context) async{
    final newDate =  await showDatePicker(
      context: context,
      initialDate: date = DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      fieldLabelText: "Выберите дату",
      fieldHintText: "Выберите дату",
      helpText:  "Выберите дату",
    );
    if (newDate == null) {
      return null;
    } else {
      setState(() {
      final String formatted = DateFormat('dd/MM/yyyy').format(newDate);
      formattedDate = formatted;
      isDate = true;
    });
    }
  }

  String dateFormatter(){
    final String formatted = DateFormat.yMMMd().format(date);
    return formatted;
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

  Future<void> _askedToLeavePage() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Вы действительно хотите выйти? Все несохранненные данные будут удалены.', textAlign: TextAlign.center,),
            children: <Widget>[Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  }, child: const Text("Да", style: TextStyle(fontSize: 20))),
                ElevatedButton(onPressed: () {Navigator.pop(context);}, child: const Text("Нет", style: const TextStyle(fontSize: 20),)),
                ],
              ),
            ),
            ],
          );
        }
    );
  }



  Future<void> chooseHint3(List<String> hints) async {

    bool isHigh1 = false;
    bool isHigh2 = false;
    bool isHigh3 = false;


    List<int> idList = [];
    late int i;
    hints.length > 2 ? i = 3 : hints.length > 1 ? i = 2 : hints.length > 0 ? i = 1 : null;
    while (i > 0) {
      int n = Random().nextInt(hints.length);
      if (!idList.contains(n)){
            idList.add(n);
            i--;
      }
    }
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              title: const Text('Выберите вопрос, на который Вы бы хотели ответить', textAlign: TextAlign.center,),
              children: <Widget>[
                Container(
                  child: hints.length > 2 ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          isHigh1 = true; isHigh2 = false; isHigh3 = false;
                          setState(() {});}, child: Text(hints.elementAt(idList.elementAt(0)), textAlign: TextAlign.center, style: TextStyle(fontSize: 16),), style: isHigh1 ? ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ): ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                        ) ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          isHigh1 = false; isHigh2 = true; isHigh3 = false;
                          setState(() {});}, child: Text(hints.elementAt(idList.elementAt(1)), textAlign: TextAlign.center, style: TextStyle(fontSize: 16),), style: isHigh2 ? ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ):ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                        )),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          isHigh1 = false; isHigh2 = false; isHigh3 = true;
                          setState(() {});}, child: Text(hints.elementAt(idList.elementAt(2)), textAlign: TextAlign.center,  style: TextStyle(fontSize: 16),), style: isHigh3 ? ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ): ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                        ) ),
                      ),

                      ElevatedButton(onPressed: (){
                        toDelete = {
                          1: hints,
                          2: idList,
                        };
                        if (isHigh1 == true){
                          isChoose1 = true;isChoose2 = false;isChoose3 = false;
                          hint1 = hints[idList[0]];
                          // hints.removeAt(idList.elementAt(0));
                          // updateHints(hints);
                          Navigator.pop(context);
                        }
                        else if (isHigh2 == true){
                          isChoose1 = false;isChoose2 = true;isChoose3 = false;
                          hint2 = hints[idList[1]];
                          // hints.removeAt(idList.elementAt(1));
                          // updateHints(hints);
                          Navigator.pop(context);
                        }
                        else if (isHigh3 == true){
                          isChoose1 = false;isChoose2 = false;isChoose3 = true;
                          hint3 = hints[idList[2]];
                          // hints.removeAt(idList.elementAt(2));
                          // updateHints(hints);
                          Navigator.pop(context);
                        }
                        else {
                          Navigator.pop(context);
                        }
                      }, child: Text('Потвердить'))
                    ],
                  ): hints.length > 1 ? Column(
                    children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(onPressed: (){
                          isHigh1 = true; isHigh2 = false; isHigh3 = false;
                          setState(() {});}, child: Text(hints.elementAt(idList.elementAt(0)), textAlign: TextAlign.center, style: TextStyle(fontSize: 16),), style: isHigh1 ? ElevatedButton.styleFrom(
                          primary: Colors.green,
                          ): ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                          ) ),
                    ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: (){
                          isHigh1 = false; isHigh2 = true; isHigh3 = false;
                          setState(() {});}, child: Text(hints.elementAt(idList.elementAt(1)), textAlign: TextAlign.center, style: TextStyle(fontSize: 16),), style: isHigh2 ? ElevatedButton.styleFrom(
                          primary: Colors.green,
                          ):ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                          )),
                        ),
                      ElevatedButton(onPressed: (){
                        toDelete = {
                          1: hints,
                          2: idList,
                        };
                        if (isHigh1 == true){
                          isChoose1 = true;isChoose2 = false;isChoose3 = false;
                          hint1 = hints[idList[0]];
                          // hints.removeAt(idList.elementAt(0));
                          // updateHints(hints);
                          Navigator.pop(context);
                        }
                        else if (isHigh2 == true){
                          isChoose1 = false;isChoose2 = true;isChoose3 = false;
                          hint2 = hints[idList[1]];
                          // hints.removeAt(idList.elementAt(1));
                          // updateHints(hints);
                          Navigator.pop(context);
                        }
                        else {
                          Navigator.pop(context);
                        }
                      }, child: Text('Потвердить'))]): hints.length > 0 ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: (){
                            isHigh1 = true; isHigh2 = false; isHigh3 = false;
                            setState(() {});}, child: Text(hints.elementAt(idList.elementAt(0)), textAlign: TextAlign.center, style: TextStyle(fontSize: 16),), style: isHigh1 ? ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ): ElevatedButton.styleFrom(
                            primary: Colors.yellow,
                          ) ),
                        ),
                        ElevatedButton(onPressed: (){
                          toDelete = {
                            1: hints,
                            2: idList,
                          };
                          if (isHigh1 == true){
                            isChoose1 = true;isChoose2 = false;isChoose3 = false;
                            hint1 = hints[idList[0]];
                            // hints.removeAt(idList.elementAt(0));
                            // updateHints(hints);
                            Navigator.pop(context);
                          }
                          else {
                            Navigator.pop(context);
                          }
                        }, child: Text('Потвердить'))
                      ]) : Center(child: Text("Вы использовали все подсказки. Ждите пополнений")),
                ),
              ],
            );
          });
        }
    );
  }


  Future<void> updateHints(List<String> hints) async{
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .update({
      "hints" : hints,
    });
  }

  Future<void> update13423() async{
    List<String> list = ["${FirebaseAuth.instance.currentUser?.uid}"];
    list.forEach((element) async{
      await FirebaseFirestore.instance.collection("UsersData")
          .doc("${element}")
          .update({
        "hints" : ["Чтобы вы в себе изменили, если могли бы?", "Как выглядит ваша идеальная жизнь?", "Каким вы себя видите через 5, 10, 20 лет?", "Что бы вы рассказали о себе незнакомцу?", "Назовите ваши пять главнейших жизненных принципов.", "Что никто не знает о вас? Почему вы храните это в секрете?"],
      });
    });
  }

  Future<void> ifEmpty() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Вы использовали все вопросы'),
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
