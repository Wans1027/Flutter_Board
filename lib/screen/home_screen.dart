import 'package:flutter/material.dart';
import 'package:flutter_board/screen/detail_screen.dart';
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
    return Scaffold(
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
                      child: Post(post: post),
                    ),
                  // Post(
                  //   post: post,
                  // ),
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
