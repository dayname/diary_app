import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/services/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



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

  var date;
  var newDate;
  String? formattedDate;
  TextEditingController textController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  @override

  bool isDate = false;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {_askedToLeavePage();}, ),
          title: const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text("Введите историю"),
          ),
        ),

        body: Container(
          padding: const EdgeInsets.all(16),
            child: Column(children: [
              const SizedBox(height: 16),
              TextField(
                style: TextStyle(color: Colors.grey),
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
                style: TextStyle(color: Colors.grey),
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
                    child: isDate ? Text("$formattedDate") : Icon(Icons.date_range, color: Colors.black,),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if((textController.text != "") & (titleController.text != "")){
                      addStory(text: textController.text, title: titleController.text);
                      Navigator.pop(context);}
                      else {
                        _showMyDialog();
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

  Future<void> addStory({required String text, required String title})
  async {
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("UserStories")
        .doc()
        .set({"title": title, "text": text, "date" : formattedDate});
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
                  }, child: Text("Да", style: TextStyle(fontSize: 20),)),
                ElevatedButton(onPressed: () {Navigator.pop(context);}, child: Text("Нет", style: TextStyle(fontSize: 20),)),

          ],),
            ),
            ],
          );
        }
    );
  }

}
