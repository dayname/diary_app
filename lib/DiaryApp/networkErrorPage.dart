import 'package:flutter/material.dart';
class networkError extends StatefulWidget {
  const networkError({Key? key}) : super(key: key);

  @override
  State<networkError> createState() => _networkErrorState();
}

class _networkErrorState extends State<networkError> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: view(),
    );
  }
  view(){
    Container(child: Column(
      children: [
        Text("Отсутствует интернет-соединение"),
        Center(
        child: ElevatedButton(onPressed: (){
          setState(() {});
        }, child: Text("Обновить")),
      ),
      ] ,
    ),
    );
  }
}
