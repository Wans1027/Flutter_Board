import 'package:flutter/material.dart';
import 'package:flutter_board/screen/websocket_screen.dart';
import 'package:flutter_board/services/findAllChatRooms_service.dart';
import 'package:flutter_board/widget/chatRoom_widget.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late Future<List<ChatRoomDataParse>> mainboard;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2, //그림자
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          "오픈채팅",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: mainboard,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //서버가 응답했을때
              //return const Text("There is data!");
              return Column(
                children: [
                  for (var post in snapshot.data!)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              //페이지넘길때 모션추가
                              builder: (context) => WebSocketScreen(
                                    roomUUID: post.roomId,
                                    roomName: post.name,
                                  )),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: ChatRoomWidget(post: post)),
                    ),
                  // Post(
                  //   post: post,
                  // ),
                  const SizedBox(
                    height: 60,
                  ),
                  //FloatingActionButton(onPressed: () {})
                ],
              );
            }

            //return const Text("Loading....");
            return const Center(
              child: CircularProgressIndicator(), //로딩중 동그라미 그림
            );
          },
        ),
      ),
    );
  }
}
