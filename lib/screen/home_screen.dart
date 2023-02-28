import 'package:flutter/material.dart';
import 'package:flutter_board/services/api_service.dart';

import '../model/mainboard_model.dart';
import '../widget/post_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final Future<List<BoardDataParse>> mainboard = ApiService.getAllPosts();

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
                    Post(
                      post: post,
                    ),
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
