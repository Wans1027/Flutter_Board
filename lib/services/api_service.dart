import 'dart:convert';

import 'package:flutter_board/model/register_model.dart';
import 'package:http/http.dart' as http;

import '../model/mainboard_model.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080/api";
  static const String text = "posts";

  static Future<List<BoardDataParse>> getAllPosts() async {
    List<BoardDataParse> postData = [];

    final url = Uri.parse('$baseUrl/$text');
    final response = await http.get(
      url,
      headers: {
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ1c2VyMyIsImlkIjoxNjAyLCJleHAiOjE2Nzk3NDM2MTQsInVzZXJuYW1lIjoidXNlcjMifQ.jhZbudHDaJ8v_OlZxWmm464p7T364V9dNu7xMwSOt3lGcA9R-Ewqy6tdz_dIadRpEafMT-eIU4vMZN15z0loHA',
      },
    );
    if (response.statusCode == 200) {
      final posts = jsonDecode(utf8.decode(response.bodyBytes));
      final aaa = MainBoardModel.fromJson(posts).content;
      for (var element in aaa) {
        postData.add(BoardDataParse.fromJson(element));
      }
      return postData;
    }
    throw Error();
  }

  static Future<DetailDataParse> getTextMain(int postId) async {
    final url = Uri.parse('$baseUrl/post/$postId');
    final response = await http.get(
      url,
      headers: {
        'Authorization':
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ1c2VyMyIsImlkIjoxNjAyLCJleHAiOjE2Nzk3NDM2MTQsInVzZXJuYW1lIjoidXNlcjMifQ.jhZbudHDaJ8v_OlZxWmm464p7T364V9dNu7xMwSOt3lGcA9R-Ewqy6tdz_dIadRpEafMT-eIU4vMZN15z0loHA',
      },
    );

    if (response.statusCode == 200) {
      final posts = jsonDecode(utf8.decode(response.bodyBytes));
      return DetailDataParse.fromJson(posts);
    }

    throw Error();
  }

  static Future<RegitserModel?> loginMember(
      String name, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'username': name, 'password': password}),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      //return RegitserModel.fromJson(jsonDecode(response.body));
      return null;
    } else {
      throw Exception('사용자 정보가 일치하지 않음');
    }
  }

  static Future<RegitserModel> registMember(
      String name, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name, 'password': password}),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return RegitserModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create register.');
    }
  }
}
