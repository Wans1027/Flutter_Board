import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_board/main.dart';
import 'package:flutter_board/model/register_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/mainboard_model.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080";
  static const String text = "posts";
  static String token = "";

  static Future<List<BoardDataParse>> getAllPosts() async {
    List<BoardDataParse> postData = [];

    final url = Uri.parse('$baseUrl/api/posts?page=0&size=20&sort=id,DESC');
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
    throw Exception('exceptioon!');
  }

  static Future<DetailDataParse> getTextMain(int postId) async {
    final url = Uri.parse('$baseUrl/api/post/$postId');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        final posts = jsonDecode(utf8.decode(response.bodyBytes));
        return DetailDataParse.fromJson(posts);
      }
    } on Exception catch (e) {
      // TODO
      print(e);
    }
    throw Exception();
  }

  static Future<LIkeDataParse> likePlus(int postId) async {
    final url = Uri.parse('$baseUrl/api/post/like/$postId');

    final response = await http.get(
      url,
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      if (Fcmtoken.isNewDevice) {}
      final posts = jsonDecode(utf8.decode(response.bodyBytes));
      return LIkeDataParse.fromJson(posts);
    } else {
      throw Exception('서버와 연결이 원할하지 않음');
    }
  }

  static Future<RegitserModel?> loginMember(
      String name, String password) async {
    Timer t = Timer(const Duration(seconds: 3), () {
      Fluttertoast.showToast(msg: "서버와 연결이 원활하지 않음");

      return;
    });
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'username': name, 'password': password}),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        var header = response.headers;
        var inToken = header["authorization"];
        print(inToken);
        token = inToken.toString();
        t.cancel();
        return null;
      } else if (response.statusCode == 401) {
        t.cancel();
        throw Exception('사용자 정보가 일치하지 않음');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
    return null;
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

  static Future<RegitserModel> postWrite(String title, String mainText) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/posts'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
      body: jsonEncode(<String, dynamic>{
        'memberId': tokenParse(token),
        'title': title,
        'mainText': mainText
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return RegitserModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('서버와 응답이 되지 않음.');
    }
  }

  static Future<RegitserModel> reviseWrite(
      String title, String mainText, int postId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/posts/$postId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
      body: jsonEncode(<String, dynamic>{
        'memberId': tokenParse(token),
        'title': title,
        'mainText': mainText
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return RegitserModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode / 100 == 4) {
      throw Exception('잘못된 요청입니다.');
    } else {
      throw Exception('서버와 응답이 되지 않음.');
    }
  }

  static Future<void> deletePost(int postId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/posts/$postId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "삭제되었습니다.");
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('서버와 응답이 되지 않음.');
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
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  static int tokenParse(String jwt) {
    //토큰에 있는 id값 가져오기
    // var payload = token.split(".")[1];
    // print(payload);
    // var result = utf8.decode(base64Url.decode(payload));
    // print(result);
    Map<String, dynamic> payload = Jwt.parseJwt(jwt);
    var id = payload['id'];
    print(id);
    //return TokenModel.fromJson(jsonDecode(result));
    return id;
  }

  static Future<List<BoardDataParse>> getSingleIdPosts() async {
    List<BoardDataParse> postData = [];

    final url = Uri.parse('$baseUrl/api/posts/${tokenParse(token)}');
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

  static Future<void> transferFCMToken() async {
    final url = Uri.parse('$baseUrl/api/FCm/${tokenParse(token)}');
    final prefs = await SharedPreferences.getInstance(); //내부저장소 접근
    final response = await http.get(
      url,
      headers: {
        'Authorization': token,
        'FCM-TOKEN': prefs.getString("FCMTOKEN")!
      },
    );

    if (response.statusCode != 200) {
      throw Exception("FCMToken을 전달하지 못함");
    }
  }
}
