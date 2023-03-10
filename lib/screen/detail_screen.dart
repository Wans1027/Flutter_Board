import 'package:flutter/material.dart';
import 'package:flutter_board/model/mainboard_model.dart';
import 'package:flutter_board/services/api_service.dart';

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

  @override
  void initState() {
    super.initState();
    mainText = ApiService.getTextMain(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
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
        body: FutureBuilder(
          future: mainText,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text('${widget.title}\n${snapshot.data!.textMain}\n ')
                ],
              );
            }
            return const Text("...");
          },
        ));
  }
}
