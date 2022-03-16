import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  TextEditingController textController = TextEditingController(text: 'It was 5 years ago');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Input Text"),
        ),

        body: Container(
            child: Column(children: [
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
                  // addStory(text: textController.text);
                  },
                  child: Text("Save story".toUpperCase()),
                ),
              )
            ],)
        )
    );
  }
 //  void addStory({required String text})
 //  async {rootBundle.loadString('assets/Stories.json')
 //    jsonEncode(
 //        "story" : "$text",
 //        ));
 //
 // }

}
