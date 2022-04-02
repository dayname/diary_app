
class Data {
  late String story;
  late String title;
  late var date;

  Data.fromJson(Map<dynamic, dynamic> json) {
    story = json["story"];
    title = json["title"];
    date = json["date"];
  }
}
