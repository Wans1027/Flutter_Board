import 'package:flutter/material.dart';
import 'package:flutter_board/screen/detail_screen.dart';
import 'package:flutter_board/screen/myPostsView_screen.dart';
import 'package:flutter_board/screen/openChatting_screen.dart';
import 'package:flutter_board/screen/writePost_screen.dart';
import 'package:flutter_board/services/api_service.dart';

import '../model/mainboard_model.dart';
import '../widget/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<BoardDataParse>> mainboard;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    mainboard = ApiService.getAllPosts();
    print("reset");
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    mainboard = ApiService.getAllPosts();

    print("state");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          elevation: 2, //그림자
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          title: const Text(
            "Wan's Board",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        drawer: const SideView(),
        floatingActionButton: SizedBox(
          width: 80,
          child: FittedBox(
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WritePost(),
                  ),
                );
              },
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              label: const Text(
                '글쓰기',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        body: RefreshIndicator(
          color: Colors.redAccent, // 스피너 화살표 색
          backgroundColor: Colors.white70, // 스피너 배경 색
          displacement: 2.0, // 스피너가 내려오는 정도
          //edgeOffset: 220.0, // 스피너가 나오는 위치
          strokeWidth: 3.0, // 스피너 화살표 크기
          onRefresh: () async {
            setState(() {});
            //mainboard = ApiService.getAllPosts();
          },
          child: SingleChildScrollView(
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
                                  builder: (context) => DetailScreen(
                                      title: post.title,
                                      writer: post.writer,
                                      likes: post.likes,
                                      postId: post.id,
                                      createdDate: post.createdDate)),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Post(post: post)),
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
      ),
      onWillPop: () async => false,
    );
  }
}

class SideView extends StatelessWidget {
  const SideView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.question_answer, color: Colors.grey[850]),
            title: const Text('내가 쓴 게시글'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyPostsView(),
                  ));
            },
            trailing: const Icon(Icons.add),
          ),
          ListTile(
            leading: Icon(Icons.question_answer, color: Colors.grey[850]),
            title: const Text('오픈채팅'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OpenChattingScreen(),
                  ));
            },
            trailing: const Icon(Icons.add),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.grey[850]),
            title: const Text('Setting'),
            onTap: () {},
            trailing: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
