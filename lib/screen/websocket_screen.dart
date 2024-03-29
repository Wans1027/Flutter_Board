import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_board/screen/openChatting_screen.dart';
import 'package:flutter_board/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketScreen extends StatefulWidget {
  final String roomUUID, roomName;

  WebSocketScreen({
    super.key,
    required this.roomUUID,
    required this.roomName,
  });

  // 웹소켓 채널을 생성
  final WebSocketChannel channel =
      // 웹 서버에 접속 시도
      IOWebSocketChannel.connect('ws://${ApiService.dns}:8080/ws/chat');

  @override
  State<WebSocketScreen> createState() => _WebSocketScreenState();
}

class _WebSocketScreenState extends State<WebSocketScreen> {
  // 상태 변화가 일어나는 필드
  final TextEditingController _controller = TextEditingController();
  late String roomId;
  var pwdWidgets = <Widget>[];
  var userName = ApiService.userName;
  //ScrollController scrollController = ScrollController();
  bool isMine = false;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        dispose();
        return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OpenChattingScreen(),
            )).then((value) {
          setState(() {});
          throw false;
        });
      },
      child: Scaffold(
        // 앱바에 타이틀 텍스트 설정. widget을 통해 MyHomePage의 필드에 접근 가능
        appBar: AppBar(title: Text(widget.roomName)),

        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Stream을 처리하기 위한 StreamBuilder 추가
                StreamBuilder(
                  // 채널의 스트림을 stream 항목에 설정. widget을 통해 MyHomePage의 필드에 접근 가능
                  stream: widget.channel.stream,
                  // 채널 stream에 변화가 발생하면 빌더 호출
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      pwdWidgets.add(chat(
                          ChatModel.fromJson(jsonDecode(snapshot.data)).message,
                          ChatModel.fromJson(jsonDecode(snapshot.data)).sender,
                          isMine));
                      isMine = false;
                      scrollJumpToBottom();
                    }
                    print("stremaam");
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      // 수신 데이터가 존재할 경우 해당 데이터를 텍스트로 출력
                      child: Column(children: pwdWidgets),
                    );
                  },
                ),
                Form(
                  child: TextFormField(
                    // 컨트롤러 항목에 _controller 설정
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Send a message'),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 플로팅 버튼이 눌리면 _sendMessage 함수 호출
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _sendMessage();
              scrollJumpToBottom();
            },
            tooltip: 'Send message',
            child: const Icon(Icons.send)),
      ),
    );
  }

  Future<void> push(BuildContext context) async {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const OpenChattingScreen()))
        .then((value) {
      setState(() {});
    });
  }

  void scrollJumpToBottom() {
    Future.delayed(const Duration(milliseconds: 30), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  // 플로팅 버튼이 눌리면 호출
  void _sendMessage() {
    isMine = true;
    // TextFormField에 입력된 텍스트가 존재하면
    if (_controller.text.isNotEmpty) {
      // 해당 텍스트를 서버로 전송. widget을 통해 MyHomePage의 필드에 접근 가능
      widget.channel.sink
          .add(createData("TALK", roomId, userName, _controller.text));
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
    //방나감
    widget.channel.sink
        .add(createData("OUT", roomId, userName, _controller.text));

    //TODO: 해당방의 세션이 0이라면 해당 방을 삭제
    // try {
    //   deleteRoom(roomId);
    // } on Exception catch (e) {
    //   Fluttertoast.showToast(msg: e.toString());
    // }
    print("Out of Room");
    // 채널을 닫음
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  void initState() {
    //myFocusNode = FocusNode();
    roomId = widget.roomUUID;
    // 해당방에 접속
    widget.channel.sink
        .add(createData("ENTER", roomId, userName, _controller.text));
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

  Row chat(String text, String userName, bool isMine) {
    return Row(
      mainAxisAlignment:
          isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              userName,
              style: const TextStyle(fontSize: 10),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(9),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.amber),
              child: Text(text),
            ),
          ],
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

Future<void> deleteRoom(String roomId) async {
  final url = Uri.parse('http://${ApiService.dns}:8080/chat?name=$roomId');
  final response = await http.delete(
    url,
    // headers: {
    //   'Authorization': token,
    //   'FCM-TOKEN': prefs.getString("FCMTOKEN")!
    // },
  );

  if (response.statusCode != 200) {
    throw Exception("Exceiption");
  }
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
