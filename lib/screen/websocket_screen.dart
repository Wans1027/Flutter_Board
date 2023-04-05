import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketScreen extends StatefulWidget {
  WebSocketScreen({super.key});

  // 웹소켓 채널을 생성
  final WebSocketChannel channel =
      // 웹 서버에 접속 시도
      IOWebSocketChannel.connect('ws://10.0.2.2:8080/ws/chat');

  @override
  State<WebSocketScreen> createState() => _WebSocketScreenState();
}

class _WebSocketScreenState extends State<WebSocketScreen> {
  // 상태 변화가 일어나는 필드
  final TextEditingController _controller = TextEditingController();
  String roomId = "9dd0658c-17c6-4b7b-856f-554b0960ea9e";
  var pwdWidgets = <Widget>[];
  //ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바에 타이틀 텍스트 설정. widget을 통해 MyHomePage의 필드에 접근 가능
      appBar: AppBar(title: const Text("웹소켓 테스입니다.")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                child: TextFormField(
                  // 컨트롤러 항목에 _controller 설정
                  controller: _controller,
                  decoration:
                      const InputDecoration(labelText: 'Send a message'),
                ),
              ),
              // Stream을 처리하기 위한 StreamBuilder 추가
              StreamBuilder(
                // 채널의 스트림을 stream 항목에 설정. widget을 통해 MyHomePage의 필드에 접근 가능
                stream: widget.channel.stream,
                // 채널 stream에 변화가 발생하면 빌더 호출
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // pwdWidgets.add(chat(snapshot.hasData
                    //     ? ChatModel.fromJson(jsonDecode(snapshot.data)).message//'${snapshot.data}' //ChatModel.fromJson(jsonDecode(snapshot.data)).message
                    //     : ''));
                    pwdWidgets.add(chat(
                        ChatModel.fromJson(jsonDecode(snapshot.data)).message));
                  }
                  print("stremaam");
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    // 수신 데이터가 존재할 경우 해당 데이터를 텍스트로 출력
                    child: Column(children: pwdWidgets),
                  );
                },
              )
            ],
          ),
        ),
      ),
      // 플로팅 버튼이 눌리면 _sendMessage 함수 호출
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _sendMessage();
          },
          tooltip: 'Send message',
          child: const Icon(Icons.send)),
    );
  }

  void scrollJumpToBottom() {
    //scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  // 플로팅 버튼이 눌리면 호출
  void _sendMessage() {
    // TextFormField에 입력된 텍스트가 존재하면
    if (_controller.text.isNotEmpty) {
      // 해당 텍스트를 서버로 전송. widget을 통해 MyHomePage의 필드에 접근 가능
      widget.channel.sink
          .add(createData("TALK", roomId, "FlutterUser", _controller.text));
    }
  }

  String createData(String type, String roomId, String sender, String message) {
    String data = jsonEncode(<String, String>{
      'type': type,
      'roomId': roomId,
      'sender': sender,
      'message': message
    });
    return data;
  }

  // 상태 클래스가 종료될 때 호출
  @override
  void dispose() {
    widget.channel.sink
        .add(createData("OUT", roomId, "FlutterUser", _controller.text));
    // 채널을 닫음
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  void initState() {
    // 해당방에 접속
    widget.channel.sink
        .add(createData("ENTER", roomId, "FlutterUser", _controller.text));
    super.initState();
  }

  // Future<void> getRoomId() async {
  //   try {
  //     var createdRoom = await postCreateRoom("테스트용");
  //     roomId = createdRoom.roomId;
  //   } on Exception catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //   } finally {
  //     // 해당방에 접속
  //     widget.channel.sink
  //         .add(createData("ENTER", roomId, "FlutterUser", _controller.text));
  //   }
  // }

  Row chat(String text) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(9),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.amber),
          child: Text(text),
        )
      ],
    );
  }
}

class ChatModel {
  final String type, roomId, sender, message;

  ChatModel.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        roomId = json['roomId'],
        sender = json['sender'],
        message = json['message'];
}

class ChatRoom {
  final String roomId, name;

  ChatRoom.fromJson(Map<String, dynamic> json)
      : roomId = json['roomId'],
        name = json['name'];
}

// Future<ChatRoom> postCreateRoom(String title) async {
//   final response = await http.post(
//     Uri.parse('http://10.0.2.2:8080/chat?name=$title'),
//     headers: {
//       'Content-Type': 'application/json; charset=UTF-8',
//       //'Authorization': token
//     },
//   );

//   if (response.statusCode == 200) {
//     // If the server did return a 201 CREATED response,
//     // then parse the JSON.
//     return ChatRoom.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('서버와 응답이 되지 않음.');
//   }
// }
/*
{
  "type":"ENTER",
  "roomId":"e4f57c65-0b0f-4972-b20c-4a024a0a4f81",
  "sender":"사용자1",
  "message":"asd"
}
*/
