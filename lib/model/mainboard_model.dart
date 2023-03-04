class MainBoardModel {
  final List data;
  final int count;

  MainBoardModel.fromJson(Map<String, dynamic> json)
      : data = json['data'],
        count = json['count'];
}

class BoardDataParse {
  final int id, memberId, likes;
  final String title, writer, createdDate;

  BoardDataParse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        writer = json['writer'],
        memberId = json['memberId'],
        title = json['title'],
        likes = json['likes'],
        createdDate = json['createdDate'];
}

//mainText Get
class DetailDataParse {
  final String textMain;
  DetailDataParse.fromJson(Map<String, dynamic> json)
      : textMain = json['textMain'];
}
