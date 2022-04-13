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


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                  icon: Icon(Icons.title, color: Colors.grey,),
                  filled: true,
                  labelText: 'Название',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16,),
              TextField(
                maxLines: 5,
                style: TextStyle(color: Colors.grey),
                controller: textController,
                decoration: const InputDecoration(
                  iconColor: Colors.yellow,
                  fillColor: Colors.white30,
                  icon: Icon(Icons.book, color: Colors.grey,),
                  filled: true,
                  labelText: 'Содержимое',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showCalendar(context);
                      },
                      child: Icon(Icons.date_range, color: Colors.black,),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        addStory(text: textController.text, title: titleController.text);
                        Navigator.pop(context);
                      },
                      child: Text("Сохранить".toUpperCase()),
                    ),
                  ]
                ),
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
      final String formatted = DateFormat('dd-MM-yyyy').format(newDate);
      formattedDate = formatted;
    });
    }
  }

  String dateFormatter(){
    final String formatted = DateFormat.yMMMd().format(date);
    return formatted;
  }

 // Future<void> getData() async{
 //     await FirebaseFirestore.instance.collection("UserData")
 //        .doc('${FirebaseAuth.instance.currentUser?.uid}')
 //        .get()
 //        .then((DocumentSnapshot doc) {
 //          var map = doc.data() as Map<String, dynamic> ;
 //        datas.add(Data.fromDoc(map));
 //        id = doc.id;
 //    });
 //
 //  }

}
