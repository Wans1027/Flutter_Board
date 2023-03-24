import 'dart:async';
import 'dart:convert';

import 'package:flutter_board/model/mainboard_model.dart';
import 'package:flutter_board/model/register_model.dart';
import 'package:flutter_board/services/api_service.dart';

import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class CommentApiService {
  static const String baseUrl = "http://10.0.2.2:8080";

  static Future<RegitserModel> commentWrite(
      int postsId, String comment, int hierarchy, int order, int group) async {
    var token = ApiService.token;
    final response = await http.post(
      Uri.parse('$baseUrl/api/comment'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
      body: jsonEncode(<String, dynamic>{
        'postsId': postsId,
        'memberId': tokenParse(token),
        'comment': comment,
        'hierarchy': hierarchy,
        'order': order,
        'group': group
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

  static Future<List<CommentDataParse>> getComments(int postId) async {
    List<CommentDataParse> postData = [];
    var token = ApiService.token;
    final url = Uri.parse('$baseUrl/api/comment/$postId');
    final response = await http.get(
      url,
      headers: {'Authorization': token},
    );
    if (response.statusCode == 200) {
      final posts = jsonDecode(utf8.decode(response.bodyBytes));
      final aaa = MainBoardModel.fromJson(posts).content;
      for (var element in aaa) {
        postData.add(CommentDataParse.fromJson(element));
      }
      return postData;
    }
    throw Error();
  }

  static int tokenParse(String jwt) {
    Map<String, dynamic> payload = Jwt.parseJwt(jwt);
    var id = payload['id'];
    return id;
  }
}

class CommentDataParse {
  final int memberId, hierarchy, order, group, like;
  final String comment, createdDate, userName;

  CommentDataParse.fromJson(Map<String, dynamic> json)
      : memberId = json['memberId'],
        userName = json['userName'],
        comment = json['comment'],
        hierarchy = json['hierarchy'],
        order = json['order'],
        group = json['group'],
        like = json['like'],
        createdDate = json['createdDate'];
}
