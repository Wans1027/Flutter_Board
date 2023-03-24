class MainBoardModel {
  final List content;
  final int totalElements;

  MainBoardModel.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        totalElements = json['totalElements'];
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
  final String images;

  DetailDataParse.fromJson(Map<String, dynamic> json)
      : textMain = json['textMain'],
        images = json['images'];
}
