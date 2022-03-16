import 'dart:convert';

import 'package:diary_app/TextInputter/InputNotes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.teal,
        accentColor: Colors.teal,
        backgroundColor: Colors.grey,
      )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Data> stories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.add),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, InputNotes.getRoute(context));
          },
          child: Icon(
            Icons.add,
            color: Colors.yellow,
          ),
        ),
        body: stories.isEmpty ? emptyViewBuild() : buildStoryList());
  }

  Container emptyViewBuild() {
    return Container(
        child: Column(
          children: [
            Text(
              "Diary App".toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 90, fontWeight: FontWeight.w900),
            ),
            ElevatedButton(onPressed: () {getStory();}, child: Text("Show the stories")),

            Text('Add your first story'),
          ],
        ),
      );
  }

  Widget buildStoryList() {
    return ListView.builder(
        itemCount: stories.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              ListTile(
                leading: Icon(Icons.face),
                title: Text("${stories[index].story}"),
              ),
              Divider()
            ],
          );
        });
  }

  getStory() async {
    print("Connecting API");
    final String response = await rootBundle.loadString('assets/Stories.json');
    var list = await json.decode(response) as List;

      print(list);

      list.forEach((element) {
        Data data = Data.fromJson(element);
        print(data.story);
        stories.add(data);

      });
      setState(() {});

  }
}
