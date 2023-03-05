class BoardModel {
  final String data, count;

  BoardModel.fromJson(Map<String, dynamic> json)
      : data = json['title'],
        count = json['thumb'];
}
