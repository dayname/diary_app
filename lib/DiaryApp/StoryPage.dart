import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/DiaryApp/DataStory.dart';
import 'package:flutter/material.dart';


class StoryPage extends StatelessWidget {
  final DataStory dataTemp;
  const StoryPage(this.dataTemp, {Key? key}) : super(key: key);

  static getRoute(DataStory dataTemp) {
    return PageRouteBuilder(transitionsBuilder: (_, animation, secondAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
    },
        pageBuilder:(_,__,___) {
          return new StoryPage(dataTemp);});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(dataTemp.title),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${dataTemp.text}", style: TextStyle(color: Colors.grey, fontSize: 20),textAlign: TextAlign.justify,),
        ),
      ),
    );
  }
}
