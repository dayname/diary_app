import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/DiaryApp/DataPage.dart';
import 'package:diary_app/DiaryApp/StoryPage.dart';
import 'package:diary_app/services/UserInfo.dart';
import 'package:diary_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'DataStory.dart';
import 'more_settings.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  List<DataStory> storyList = [];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            PopupMenuButton(onSelected: choiceAction,
              color: Colors.yellow,
              itemBuilder: (BuildContext context) {
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToDataPage();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            "+", style: const TextStyle(fontFamily: 'Rostov', fontSize: 40,),),
        ),
      ),
      body:
      FutureBuilder<List<DataStory>>(
        future: getStory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
    return Text('${snapshot.error}', style: TextStyle(color: Colors.white),);
    }
          if (snapshot.connectionState == ConnectionState.done) {
          storyList = snapshot.data!;
          if (storyList.isEmpty)
           { return emptyViewBuild();}
          else
            {return listBuilder(storyList);}

    }

    return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ));
        }
      ),
    );
  }

  emptyViewBuild() {
    return Container(
      child:
          Center(
          child: Text(
            '${userInfo.getInfo().name}, напишите свою первую историю',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25,
                fontFamily: 'Rostov',
                color: Colors.yellow.withOpacity(0.5)),
          )
       )
    );
  }
  

  listBuilder(List<DataStory> storyList) {
    return RefreshIndicator(
      onRefresh: () async{
        storyList = [];
        await getStory();
        setState(() {});
        return Future.value();
      },
      child: ListView.builder(
          itemCount: storyList.length,
          itemBuilder: (BuildContext context, index) {
            return Container(
                child: Column(children: [
                  ListTile(
                    onTap: () {
                        Navigator.push(context, StoryPage.getRoute(storyList[index]));
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
                      "${storyList[index].title}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    subtitle: storyList[index].date != null ? Text("${storyList[index].date}",
                        style: TextStyle(color: Colors.grey)) : null,
                    trailing: IconButton(onPressed: (){
                      setState(() {
                        delete(storyList[index].docId);
                      });
                    }, icon: Icon(
                        Icons.delete_outline,
                        color: Colors.white70,),
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
          }),
    );
  }

  goToDataPage() async {
    await Navigator.push(
        context, InputNotes.getRoute(context));
    setState(() {});
      }



  void choiceAction(String choice) {
    if (choice == Constants.LogOut) {
      AuthService().logOut();
    }
  }

 Future<List<DataStory>> getStory() async {
        List<DataStory> stories = [];
    await FirebaseFirestore.instance
        .collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("UserStories")
        .get()
        .then((QuerySnapshot querySnapshot){
          querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
            stories.add(DataStory.fromDoc(doc));
          });
    });
        return stories;
  }

  delete(String docId) async {
    await FirebaseFirestore.instance.collection("UsersData")
        .doc("${userInfo.getInfo().user_id}")
        .collection("UserStories").doc("${docId}").delete();
  }
}
