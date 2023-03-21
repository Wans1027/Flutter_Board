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
  String imageURL = "http://10.0.2.2:8080/items/get/";

  @override
  void initState() {
    super.initState();
    try {
      mainText = ApiService.getTextMain(widget.postId);
    } catch (e) {
      print(e);
    }
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
                      print(imageList[0]);
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
                                  Text(
                                    widget.writer,
                                    style: const TextStyle(fontSize: 22),
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
                                        })) //Image.network("$imageURL$image"),
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
            // Container(
            //   width: 300,
            //   height: 300,
            //   decoration: BoxDecoration(border: Border.all()),
            //   child: Image.network(
            //       "${imageURL}3f6b4558-2486-4778-a754-27e63332d1a1.jpg"),
            // )
          ],
        ),
      ),
    );
  }
}
