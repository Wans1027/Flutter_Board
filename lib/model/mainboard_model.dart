class MainBoardModel {
  final List data;
  final int count;

  MainBoardModel.fromJson(Map<String, dynamic> json)
      : data = json['data'],
        count = json['count'];
}

class BoardDataParse {
  final int id, memberId;
  final String title;

  BoardDataParse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        memberId = json['memberId'],
        title = json['title'];
}
