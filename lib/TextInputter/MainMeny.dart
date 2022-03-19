import 'package:diary_app/TextInputter/InputNotes.dart';
import 'package:flutter/material.dart';

import 'Data.dart';
import 'getData.dart';

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
  int selectindex = -1;
  int index = 0;
  List<Map> getStories = [];
  List<Data> stories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(alignment: Alignment.center,
              child: Text("DiaryApp", style: TextStyle(fontSize: 35,),)),
        ),
        floatingActionButton: selectindex == -1 ? FloatingActionButton(
          onPressed: () {
            goToSecondScreen() ;
          },
          child: Icon(
            Icons.add,
          ),
        ) : FloatingActionButton(
          onPressed: () {

            setState(() {
              selectindex = -1;
            });
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        body: emptyViewBuild());
  }

  Container emptyViewBuild() {
    return Container(
      child: stories.isEmpty
          ? Center(
          child: Text('Add your first story', style: TextStyle(fontSize: 40,),))
          : buildStoryList(),
    );
  }

  Widget buildStoryList() {
    return selectindex==-1 ? listBuilder() : story();}




  listBuilder(){
    return ListView.builder(
        itemCount: stories.length,
        itemBuilder: (BuildContext context, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
                children:[
                  ListTile(
                    onTap: ()
                    {
                      setState(() {
                        selectindex = index;
                      });},
                    horizontalTitleGap: 5,
                    leading: Text("${index + 1}", style: TextStyle(fontSize: 18,),),
                    title: Text("${stories[index].title}", style: TextStyle(fontSize: 20),),
                    subtitle: Text("${stories[index].date}",),
                    trailing: Icon(Icons.delete),
                  ),
                  Divider(),]
            ),
          );
        }
    );
  }
  story(){
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
      children: [
        Align(alignment: Alignment.center ,child: Text("${stories[selectindex].title}", style: TextStyle(fontSize: 25),)),
        SizedBox(height: 10,),
        Text("${stories[selectindex].story}", style: TextStyle(fontSize: 18),),
      ],
    ));
  }

  goToSecondScreen() async {
    stories.clear();
    final result = await Navigator.push(
        context, InputNotes.getRoute(context)) as List<dynamic>;


    setState(() {
      getData getdata = getData.toMap(result);
      getStories.add(getdata.getStory);
      getStories.forEach((element) {
        Data data = Data.fromJson(element);
        stories.add(data);
      });
    });
  }
}





