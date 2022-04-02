import 'package:diary_app/DiaryApp/DataPage.dart';
import 'package:diary_app/DiaryApp/LoginSignupPage.dart';
import 'package:diary_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Data.dart';
import 'getData.dart';
import 'more_settings.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectindex = -1;
  int index = 0;
  List<Map> getStories = [];
  List<Data> stories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectindex == -1
          ? AppBar(
              actions: [
                PopupMenuButton(onSelected: choiceAction,
                color: Colors.yellow,
                  itemBuilder: (BuildContext context){
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem(value: choice,
                    child: Text(choice),);
                  }).toList();
                },)
              ],
              elevation: 4,
              title: Padding(
                      padding: const EdgeInsets.only(top: 6, left: 105),
                      child: Text("Diary App".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
              )
      )

          : AppBar(
          title: Text(
            "${stories[selectindex].title}",
            style: const TextStyle(fontSize: 18),
          ),
          leading: IconButton(
              onPressed: () {
                setState(() {
                  selectindex = -1;
                });
              },
              icon: const Icon(Icons.arrow_back))),
      floatingActionButton: selectindex == -1
          ? FloatingActionButton(
        onPressed: () {
          goToSecondScreen();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            "+", style: const TextStyle(fontFamily: 'Rostov', fontSize: 40,),),
        ),
      )
          : null,
      body: emptyViewBuild(),
    );
  }
 emptyViewBuild() {
    return Container(
      child: stories.isEmpty
          ? Center(
          child: Text(
            '${FirebaseAuth.instance.currentUser
                ?.displayName}, напишите свою первую историю',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25,
                fontFamily: 'Rostov',
                color: Colors.yellow.withOpacity(0.5)),
          ))
          : buildStoryList(),
    );
  }

  Widget buildStoryList() {
    return selectindex == -1 ? listBuilder() : story();
  }

  listBuilder() {
    return ListView.builder(
        itemCount: stories.length,
        itemBuilder: (BuildContext context, index) {
          return Container(
              child: Column(children: [
                ListTile(
                  onTap: () {
                    setState(() {
                      selectindex = index;
                    });
                  },
                  horizontalTitleGap: -4,
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  title: Text(
                    "${stories[index].title}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: Text("${stories[index].date}",
                      style: TextStyle(color: Colors.grey)),
                  trailing: const Icon(
                    Icons.delete_outline,
                    color: Colors.white70,
                  ),
                ),
                Container(
                  height: 1,
                  width: 500,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ]));
        });
  }

  story() {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "${stories[selectindex].story}",
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ));
  }

  goToSecondScreen() async {
    stories.clear();
    final result = await Navigator.push(context, InputNotes.getRoute(context)) as List<dynamic>;

    setState(() {
      getData getdata = getData.toMap(result);
      getStories.add(getdata.getStory);
      getStories.forEach((element) {
        Data data = Data.fromJson(element);
        stories.add(data);
      });
    });
  }


  void choiceAction(String choice){
    if(choice == Constants.LogOut){
      AuthService().logOut();
    }
  }
}
