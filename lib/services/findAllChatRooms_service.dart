import 'dart:async';
import 'dart:convert';

import 'package:flutter_board/services/api_service.dart';

import 'package:http/http.dart' as http;

import '../model/mainboard_model.dart';

class ChatApiService {
  static const String baseUrl = ApiService.baseUrl;

  static Future<List<ChatRoomDataParse>> getChattingRooms() async {
    List<ChatRoomDataParse> postData = [];
    var token = ApiService.token;
    final url = Uri.parse('$baseUrl/chat');
    final response = await http.get(
      url,
      headers: {'Authorization': token},
    );
    if (response.statusCode == 200) {
      final posts = jsonDecode(utf8.decode(response.bodyBytes));
      final aaa = MainBoardModel.fromJson(posts).content;
      for (var element in aaa) {
        postData.add(ChatRoomDataParse.fromJson(element));
      }
      return postData;
    }
    throw Exception('서버와 응답이 되지 않음.');
  }

  static Future<CreateRoomDataParse> createChattingRoom(String roomName) async {
    var token = ApiService.token;
    final url = Uri.parse('$baseUrl/chat?name=$roomName');
    final response = await http.post(
      url,
      headers: {'Authorization': token},
    );
    if (response.statusCode == 200) {
      return CreateRoomDataParse.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    }
    throw Exception('서버와 응답이 되지 않음.');
  }
}

class ChatRoomDataParse {
  final String roomId, name;
  final int count;
  ChatRoomDataParse.fromJson(Map<String, dynamic> json)
      : roomId = json['roomId'],
        name = json['name'],
        count = json['count'];
}

class CreateRoomDataParse {
  final String roomId, name;

  CreateRoomDataParse.fromJson(Map<String, dynamic> json)
      : roomId = json['roomId'],
        name = json['name'];
}
