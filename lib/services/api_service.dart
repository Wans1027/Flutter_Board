import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_board/model/main_model.dart';
import 'package:flutter_board/model/register_model.dart';
import 'package:http/http.dart' as http;

import '../model/mainboard_model.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080";
  static const String text = "posts";
  static String token = "";
  static Future<List<BoardDataParse>> getAllPosts() async {
    List<BoardDataParse> postData = [];

    final url = Uri.parse('$baseUrl/api/$text');
    final response = await http.get(
      url,
      headers: {'Authorization': token},
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
    final url = Uri.parse('$baseUrl/api/post/$postId');
    final response = await http.get(
      url,
      headers: {'Authorization': token},
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
      var header = response.headers;
      var authtoken = header["authorization"];
      print(authtoken);
      token = authtoken.toString();
      return null;
    } else {
      throw Exception('사용자 정보가 일치하지 않음');
    }
  }

  static Future<RegitserModel> registMember(
      String username, String password, String password2) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password1': password,
        'password2': password2
      }),
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

  static Future<dynamic> patchUserProfileImage(
      dynamic input, int postId) async {
    print("프로필 사진을 서버에 업로드 합니다.");
    var dio = Dio();
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;

      dio.options.headers = {'Authorization': token};
      var response = await dio.post(
        '$baseUrl/items/new/$postId',
        data: input,
      );
      print('성공적으로 업로드했습니다');
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  static TokenModel? tokenParse() {
    //토큰에 있는 id값 가져오기
    var payload = token.split(".")[1];
    var result = utf8.decode(base64Url.decode(payload));
    return TokenModel.fromJson(jsonDecode(result));
  }
}
