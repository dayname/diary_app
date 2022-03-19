import 'package:flutter/cupertino.dart';
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
          title: Text("Enter the story"),
        ),

        body: Container(
          padding: EdgeInsets.all(16),
            child: Column(children: [
              ElevatedButton(
                onPressed: () {
                  _showCalendar(context);
                },
                child: Text("Specify date".toUpperCase()),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15)
                ),
              ),
               SizedBox(height: 16),
              TextField(
                maxLines: 1,
                controller: titleController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.book),
                  filled: true,
                  hintText: "Name your story",
                  labelText: 'Name',
                ),
              ),
            SizedBox(height: 16,),
              TextField(
                maxLines: 5,
                controller: textController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.book),
                  filled: true,
                  hintText: "Write your story here",
                  labelText: 'Story',
                ),
              ),
              SizedBox(height: 16,),

              Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                    addStory(text: textController.text, title: titleController.text);
                    },
                    child: Text("Save story".toUpperCase()),
                  ),
                ),
            ],)
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
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'SPECIFY DATE',
      fieldLabelText: 'Specify date',
    );
    if (newDate == null) return;
    setState(() {
      date = newDate;
    });

  }


}
