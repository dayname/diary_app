class Data {
  late String story;

  Data({required this.story});

  Data.fromJson(Map<String, dynamic> map) {
    story = map["story"];
  }

}