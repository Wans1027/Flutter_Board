import 'package:flutter/material.dart';
import 'package:flutter_board/screen/home_screen.dart';
import 'package:flutter_board/screen/websocket_screen.dart';
import 'package:flutter_board/services/findAllChatRooms_service.dart';
import 'package:flutter_board/widget/chatRoom_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OpenChattingScreen extends StatefulWidget {
  const OpenChattingScreen({super.key});

  @override
  State<OpenChattingScreen> createState() => _OpenChattingScreen();
}

class _OpenChattingScreen extends State<OpenChattingScreen> {
  late Future<List<ChatRoomDataParse>> mainboard;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    try {
      mainboard = ChatApiService.getChattingRooms();
    } on Exception catch (e) {
      print(e.toString());
    }

    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    try {
      mainboard = ChatApiService.getChattingRooms();
    } on Exception catch (e) {
      print(e.toString());
    }
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            )).then((value) {
          setState(() {});
          throw false;
        });
      },
      child: Scaffold(
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
          actions: [
            IconButton(
                onPressed: () {
                  flutterDialog();
                },
                icon: const Icon(
                  Icons.fiber_new_rounded,
                ))
          ],
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
      ),
    );
  }

  void flutterDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        //barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: const [
                Text("오픈채팅방생성"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "오픈채팅방이름",
                ),
                Form(
                  child: TextFormField(
                    // 컨트롤러 항목에 _controller 설정
                    controller: _controller,
                    decoration: const InputDecoration(labelText: '채팅방이름'),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("방생성"),
                onPressed: () async {
                  try {
                    var createRoom = await ChatApiService.createChattingRoom(
                        _controller.text);
                    if (context.mounted) pageRouteWebsocket(createRoom);
                  } on Exception catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  }

                  //Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void pageRouteWebsocket(CreateRoomDataParse createRoom) {
    Navigator.push(
      context,
      MaterialPageRoute(
          //페이지넘길때 모션추가
          builder: (context) => WebSocketScreen(
                roomUUID: createRoom.roomId,
                roomName: createRoom.name,
              )),
    );
  }
}
