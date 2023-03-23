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

/*
Widget _FetchAllPosts(context) {
    return FutureBuilder(
        future: _allPosts,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 요청으로 부터 아직 응답이 없는 경우
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // 에러가 발생한 경우
            } else { // hasData 
              // 정상적으로 데이터를 수신한 경우
            }
          } else {
            // Future 객체가 null 인 경우
          }
        }));
  }
  */