class TVSeries {
  int id;
  String title;
  int episodes;
  String image;
  String description;

  TVSeries({this.description, this.episodes, this.id, this.image, this.title});

  TVSeries.fromDbMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        image = map['image'],
        episodes = map['episodes'],
        description = map['description'];
  Map<String, dynamic> toDbMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['image'] = image;
    map['episodes'] = episodes;
    map['description'] = description;
    return map;
  }
}
