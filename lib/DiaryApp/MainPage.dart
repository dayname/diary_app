import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/DiaryApp/DataPage.dart';
import 'package:diary_app/DiaryApp/StoryPage.dart';
import 'package:diary_app/DiaryApp/confirmEmail.dart';
import 'package:diary_app/DiaryApp/editPage.dart';
import 'package:diary_app/DiaryApp/profilePage.dart';
import 'package:diary_app/utils/UserInfo.dart';
import 'package:diary_app/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../utils/DataStory.dart';
import 'LoginPage.dart';
import '../utils/more_settings.dart';

class MyHomePage extends StatefulWidget {
  final User user;

  MyHomePage({required this.user});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
late User currentUser;
class _MyHomePageState extends State<MyHomePage> {
  @override
  List<DataStory> storyList = [];
  FirebaseAuth firebase = FirebaseAuth.instance;
  void initState() {
    currentUser = widget.user;
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: PopupMenuButton(onSelected: choiceAction,
                color: Colors.yellow,
                itemBuilder: (BuildContext context) {
                  return Constants.choices.map((String choice) {
                    return PopupMenuItem(value: choice,
                      child: Text(choice),);
                  }).toList();
                },),
            )
          ],
          elevation: 4,
          title: Padding(
            padding: const EdgeInsets.only(top: 6, left: 110),
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
          {
             return emptyViewBuild();}
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

  emptyViewBuild(){
    return Container(
      child:
          Center(
          child: Text(
            '${currentUser.displayName}, напишите свою первую историю',
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(children: [
                    ListTile(
                      onTap: () {
                          Navigator.push(context, StoryPage.getRoute(storyList[index]));
                      },
                      horizontalTitleGap: -4,
                      leading: Padding(
                        padding: const EdgeInsets.all(3),
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
                          style: TextStyle(color: Colors.grey)) : Text(""),
                      trailing: Row(mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () async{
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => editStory(storyList[index]),
                              ),
                            );
                            setState(() {});
                          }, icon: Icon(
                            Icons.edit,
                            color: Colors.white70,),
                          ),
                          IconButton(onPressed: (){
                            _askedToDelete(storyList[index]);
                          }, icon: Icon(
                              Icons.delete_outline,
                              color: Colors.white70,),
                          ),
                        ],
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
                  ]),
                ));
          }),
    );
  }

  goToDataPage() async {
    await Navigator.push(
        context, InputNotes.getRoute(context));
    setState(() {});
      }



  void choiceAction(String choice) async{
    if (choice == Constants.LogOut) {
      _askedToLogOut();
    }
    if (choice == Constants.Settings){
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => profilePage(),
          ));
    }
  }

  Future<void> _askedToLogOut() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Вы действительно хотите выйти из аккаунта?', textAlign: TextAlign.center,),
            children: <Widget>[Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: () async {
                    Navigator.pop(context);
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        )
                    );
                  }, child: Text("Да", style: TextStyle(fontSize: 20),)),
                  ElevatedButton(onPressed: () {Navigator.pop(context);}, child: Text("Нет", style: TextStyle(fontSize: 20),)),
                ],
              ),
            ),
            ],
          );
        }
    );
  }


  Future<void> _askedToDelete(DataStory story) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Вы действительно хотите удалить "${story.title}"?', textAlign: TextAlign.center,),
            children: <Widget>[Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      delete(story.docId);
                    });
                  }, child: Text("Да", style: TextStyle(fontSize: 20),)),
                  ElevatedButton(onPressed: () {Navigator.pop(context);}, child: Text("Нет", style: TextStyle(fontSize: 20),)),

                ],),
            ),
            ],
          );
        }
    );
  }

 Future<List<DataStory>> getStory() async {
        List<DataStory> stories = [];
    await FirebaseFirestore.instance
        .collection("UsersData")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("UserStories")
        .orderBy("counterOfStory", descending: false)
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
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("UserStories").doc(docId).delete();
  }
}
