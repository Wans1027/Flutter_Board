import 'package:flutter/material.dart';
import 'package:flutter_board/screen/home_screen.dart';
import 'package:flutter_board/screen/revisePost_screen.dart';
import 'package:flutter_board/services/api_service.dart';

import '../model/mainboard_model.dart';
import '../widget/post_widget.dart';

class MyPostsView extends StatefulWidget {
  const MyPostsView({super.key});

  @override
  State<MyPostsView> createState() => _MyPostsViewState();
}

class _MyPostsViewState extends State<MyPostsView> {
  late Future<List<BoardDataParse>> mainboard;

  @override
  void initState() {
    super.initState();
    mainboard = ApiService.getSingleIdPosts();
    print("reset");
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    mainboard = ApiService.getSingleIdPosts();
    print("state");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2, //그림자
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          "내가 쓴 게시글",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      //drawer: const SideView(),
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
                              builder: (context) => RevisePost(
                                  title: post.title,
                                  writer: post.writer,
                                  likes: post.likes,
                                  postId: post.id,
                                  createdDate: post.createdDate)),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Post(post: post),
                    ),

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

class SideView extends StatelessWidget {
  const SideView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      child: ListView(
        children: [
          ListTile(
            leading: SizedBox(
                width: 10, child: Icon(Icons.home, color: Colors.grey[850])),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.grey[850]),
            title: const Text('Setting'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
