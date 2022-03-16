import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// this is your APP Main screen configuration
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

/// this is a template to start building a UI
/// to start adding any UI you want change what comes after the [ body: ] tag below
class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      /*******************--[focus here 🧐]--*******************/
      appBar: AppBar(
        leading: const Icon(Icons.book),
        title: const Text('DiaryApp'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: myWidget(),
      /*******************--[focus here 🧐]--*******************/
    );
  }
  TextEditingController titleController = TextEditingController(text: '');
  Widget myWidget() {
    return Container(
        padding: EdgeInsets.all(20),
        child:
        /*******************--[focus here 🧐]--*******************/
        TextField(
          maxLines: 300,
          textAlign: TextAlign.justify,
          controller: titleController,
          decoration: const InputDecoration(
            icon: Align(alignment: Alignment.topLeft,child: Icon(Icons.title, color: Colors.teal,)),
            filled: true,
            hintText: 'Write your story here',
            labelText: 'Story',
          ),
        ),
      /*******************--[focus here 🧐]--*******************/
    );
  }
}
