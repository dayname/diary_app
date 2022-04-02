import 'package:flutter/material.dart';

import 'Data.dart';


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

  TextEditingController textController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text("Введите запись"),
          ),
          leading: Align(alignment: Alignment.centerRight, child: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back),))
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
                  icon: Icon(Icons.book, color: Colors.grey,),
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

              Stack(
                children: [ Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                      addStory(text: textController.text, title: titleController.text);
                      },
                      child: Text("Сохранить".toUpperCase()),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        _showCalendar(context);
                      },
                      child: Text("Выбрать дату".toUpperCase()),
                    ),
                  ),
                ]
              ),
            ],
            )
        )
    );
  }
  void addStory({required String text, required String title})
  {
    Navigator.pop(context, [text, title, date]);
    // .replaceRange(10, date.length, '')
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
    if (newDate == null) return;
    setState(() {
      date = newDate;
    });
  }
}
