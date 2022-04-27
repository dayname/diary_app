import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/utils/DataStory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class editStory extends StatefulWidget {
  final DataStory dataStory;
  const editStory(this.dataStory, {Key? key}) : super(key: key);

  @override
  State<editStory> createState() => _editStoryState();
}


class _editStoryState extends State<editStory> {
  @override
  var date;
  var newDate;
  String? formattedDate;
  bool isDate = false;
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController(text: widget.dataStory.text);
    TextEditingController titleController = TextEditingController(text: widget.dataStory.title);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {_askedToLeavePage();}, ),
          title: const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text("Редактирование"),
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
                  // hintText: dataStory.text,
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
                      onPressed: () async{
                        if((textController.text != "") & (titleController.text != "")){
                          await updateStory(text: textController.text, title: titleController.text);
                          Navigator.pop(context);
                        }
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



  Future<void> updateStory({required String text, required String title})
  async {
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("UserStories")
        .doc("${widget.dataStory.docId}")
        .update({"title": title, "text": text, "date" : formattedDate});
  }

  Future _showCalendar(BuildContext context) async{
    formattedDate = widget.dataStory.date;
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
