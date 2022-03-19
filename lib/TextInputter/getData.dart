class getData {
  Map<String, dynamic> getStory = {};



  getData.toMap(List result) {
    getStory = {"story": result[0], "title": result[1], "date": result[2]};
  }


}