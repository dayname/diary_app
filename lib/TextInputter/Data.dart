// class Data {
//   Map<String, dynamic> getStory = {};
//   late String story;
//   Data(this.story);
//
//   Data.toMap(String text) {
//     getStory = {"story": text};
//   }
//
//   Data.fromJson(Map<dynamic, dynamic> json) {
//     story = json["story"];
//   }
//
// }




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