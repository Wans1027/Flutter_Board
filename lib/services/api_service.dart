import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/mainboard_model.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080/api";
  static const String text = "posts";

  static Future<List<BoardDataParse>> getAllPosts() async {
    List<BoardDataParse> postData = [];

    final url = Uri.parse('$baseUrl/$text');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final posts = jsonDecode(utf8.decode(response.bodyBytes));
      final aaa = MainBoardModel.fromJson(posts).data;
      for (var element in aaa) {
        postData.add(BoardDataParse.fromJson(element));
      }
      return postData;
    }
    throw Error();
  }

  static Future<DetailDataParse> getTextMain(int postId) async {
    final url = Uri.parse('$baseUrl/post/$postId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final posts = jsonDecode(utf8.decode(response.bodyBytes));
      return DetailDataParse.fromJson(posts);
    }

    throw Error();
  }

  void getAllPost() async {
    final testUrl = Uri.parse("http://10.0.2.2:8080/api/posts-entity");
    final response = await http.get(testUrl);
    if (response.statusCode == 200) {
      print(response.body);
      return;
    }
    throw Error();
  }
}
