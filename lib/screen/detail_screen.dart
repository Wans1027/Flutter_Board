import 'package:flutter/material.dart';
import 'package:flutter_board/model/mainboard_model.dart';
import 'package:flutter_board/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/commentApi_service.dart';

class DetailScreen extends StatefulWidget {
  final String title, writer, createdDate;
  final int likes, postId;
  const DetailScreen(
      {super.key,
      required this.title,
      required this.writer,
      required this.likes,
      required this.postId,
      required this.createdDate});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<DetailDataParse> mainText;
  late Future<List<CommentDataParse>> comments;
  final commentText = TextEditingController();

  String imageURL = "http://${ApiService.dns}:8080/items/get/";

  int cnt = 0;
  int ccnt = 0;
  bool isComment = true;
  FocusNode myFocusNode = FocusNode();
  int group = 0;
  int like = 0;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    like = widget.likes;
    group = 0;
    try {
      comments = CommentApiService.getComments(widget.postId);
      mainText = ApiService.getTextMain(widget.postId);
    } catch (e) {}
  }

  @override
  void setState(VoidCallback fn) {
    isComment = true;
    comments = CommentApiService.getComments(widget.postId);
    super.setState(fn);
  }

  @override
  void dispose() {
    // 폼이 삭제되면 myFocusNode도 삭제됨
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cnt = 0;
    ccnt = 0;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        centerTitle: true,
        elevation: 2, //그림자
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        // title: Text(
        //   widget.title, //wiget 은 father 즉 DetailScreen 클래스를 명시
        //   style: const TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 5, 10, 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: TextField(
                    controller: commentText,
                    focusNode: myFocusNode,
                    decoration: InputDecoration(
                      hintText: isComment ? '댓글을 입력하세요' : '대댓글을 입력하세요',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Transform.rotate(
                  angle: -0.7,
                  child: IconButton(
                      onPressed: () async {
                        //댓글전송
                        isComment
                            ? await submitComment(0, cnt + 1) //댓글전송
                            : await submitComment(1, group); //대댓글전송
                        if (context.mounted) FocusScope.of(context).unfocus();
                        commentText.clear();
                      },
                      icon: const Icon(
                        Icons.send,
                        fill: 0.5,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: mainText,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var imageList = snapshot.data!.images.split(", ");
                      //print(imageList[0]);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 350,
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.account_box_sharp),
                                      Text(
                                        widget.writer,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      //메인 좋아요
                                      const Icon(Icons.thumb_up),
                                      Text(like.toString())
                                    ],
                                  ),
                                  Text(widget.createdDate)
                                ],
                              ),
                            ),
                            Text(
                              widget.title,
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              snapshot.data!.textMain,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            for (var image in imageList)
                              if (imageList[0] != " ")
                                SizedBox(
                                    width: 300,
                                    //height: 300,
                                    //decoration: BoxDecoration(border: Border.all()),
                                    child: Image(
                                      image: NetworkImage("$imageURL$image",
                                          headers: {
                                            "Authorization":
                                                "Bearer ${ApiService.token}"
                                          }),
                                    ) //Image.network("$imageURL$image"),
                                    ),
                          ],
                        ),
                      );
                    }
                    return const Text("...");
                  },
                ),
              ],
            ),
            OutlinedButton.icon(
              onPressed: () async {
                try {
                  await ApiService.likePlus(widget.postId);
                  setState(() {
                    like++;
                  });
                } on Exception catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              },
              icon: const Icon(Icons.thumb_up_outlined),
              label: const Text('추천하기'),
            ),
            FutureBuilder(
              future: comments,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      for (var com in snapshot.data!)
                        com.hierarchy == 0
                            ? motherComment(com)
                            : childComment(com)
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(), //로딩중 동그라미 그림
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitComment(int hiererach, int group) async {
    try {
      await CommentApiService.commentWrite(
          widget.postId, commentText.text, hiererach, 1, group);
      setState(() {});
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Padding childComment(CommentDataParse com) {
    ccnt++;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Container(
        padding: const EdgeInsets.all(4),
        width: double.infinity,
        // decoration: const BoxDecoration(
        //     border: Border(bottom: BorderSide(color: Colors.black))),
        child: Row(
          children: [
            const SizedBox(
              width: 25,
            ),
            const Icon(
              Icons.subdirectory_arrow_right_rounded,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: 280,
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commentStyle(com),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<dynamic, dynamic> bkey = {};

  Padding motherComment(CommentDataParse com) {
    cnt++;
    ccnt++;
    var key = cnt;
    var likeOrder = ccnt;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black))),
        //color: Colors.black26,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            commentStyle(com),
            IconButton(
              //key: ValueKey(key),
              //대댓글달기
              onPressed: () async {
                FocusScope.of(context).requestFocus(myFocusNode); //키보드 숨기기
                isComment = false;
                group = key;
                //await submitComment(1, key);
              },
              icon: const Icon(Icons.chat_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Column commentStyle(CommentDataParse com) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.account_box_sharp),
              const SizedBox(
                width: 5,
              ),
              Text(
                com.userName,
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ],
          ),
        ],
      ),
      Text(
        com.comment,
        style: const TextStyle(fontSize: 16),
      ),
      Text(com.createdDate)
    ]);
  }
}
