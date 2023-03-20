class BoardModel {
  final String data, count;

  BoardModel.fromJson(Map<String, dynamic> json)
      : data = json['title'],
        count = json['thumb'];
}

class TokenModel {
  final int id;

  TokenModel.fromJson(Map<String, dynamic> json) : id = json['id'];
}
