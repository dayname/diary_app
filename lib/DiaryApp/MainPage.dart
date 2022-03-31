import 'package:diary_app/DiaryApp/DataPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Data.dart';
import 'getData.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => print(value.options.projectId));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Rostov',
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.yellow,
            accentColor: Colors.yellowAccent,

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
        appBar:selectindex ==-1 ? AppBar(
          elevation: 4,
          title: Align(alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text("Diary App".toUpperCase(), style: const TextStyle(fontSize: 30,),),
              )),
        ) : AppBar(title: Text("${stories[selectindex].title}", style: const TextStyle(fontSize: 18),),
            leading: IconButton(onPressed: () {setState(() {
          selectindex = -1;
        });}, icon: const Icon(Icons.arrow_back))),
        floatingActionButton: selectindex == -1 ? FloatingActionButton(
          onPressed: () {
            goToSecondScreen() ;
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text("+", style: const TextStyle(fontFamily: 'Rostov', fontSize: 40,),
            ),
          ),
        ) : null,
        body: emptyViewBuild());
  }

  Container emptyViewBuild() {
    return Container(
      child: stories.isEmpty
          ? Center(
          child: Text('Напишите свою первую историю', style: TextStyle(fontSize: 25, fontFamily: 'Rostov',color: Colors.yellow.withOpacity(0.5)),))
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
            child: Column(
                children:[
                  ListTile(
                    onTap: ()
                    {setState(() {
                        selectindex = index;
                      });},
                    horizontalTitleGap: -4,
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text("${index + 1}", style: const TextStyle(fontSize: 18,          color: Colors.grey, ),),
                    ),
                    title: Text("${stories[index].title}", style: const TextStyle(fontSize: 20, color: Colors.grey, ),),
                    subtitle: Text("${stories[index].date}", style: TextStyle( color: Colors.grey)),
                    trailing: const Icon(Icons.delete_outline, color: Colors.white70,),
                  ),
                  Container(
                    height: 1,
                    width: 500,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.rectangle,
                    ),
                  ),
        ])
          );
        }
    );
  }
  story(){
    return Container(
        padding: const EdgeInsets.all(16),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
      children: [
            Text("${stories[selectindex].story}", style: const TextStyle(fontSize: 18,  color: Colors.grey),),
      ],
    ),
          ),
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





