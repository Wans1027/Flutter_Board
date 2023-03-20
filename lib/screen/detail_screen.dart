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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder(
                future: mainText,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text(
                          '${widget.title}\n${snapshot.data!.textMain}\n ',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    );
                  }
                  return const Text("...");
                },
              ),
            ],
          ),
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(border: Border.all()),
            child: Image.network(
                "http://10.0.2.2:8080/items/get/3f6b4558-2486-4778-a754-27e63332d1a1.jpg"),
          )
        ],
      ),
    );
  }
}
