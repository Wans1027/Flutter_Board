import 'dart:io';
import 'package:flutter_board/model/register_model.dart';
import 'package:flutter_board/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/mainboard_model.dart';

class RevisePost extends StatefulWidget {
  final String title, writer, createdDate;
  final int likes, postId;

  const RevisePost(
      {super.key,
      required this.title,
      required this.writer,
      required this.likes,
      required this.postId,
      required this.createdDate});

  @override
  State<RevisePost> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<RevisePost> {
  late Future<DetailDataParse> mainTextFuture;
  late TextEditingController title;
  late TextEditingController mainText;

  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  FormData? formData;

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        imagefiles = pickedfiles;
        final List<MultipartFile> files = imagefiles!
            .map((img) => MultipartFile.fromFileSync(img.path,
                contentType: MediaType("image", "jpg")))
            .toList();
        formData = FormData.fromMap({"file": files});
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  late Future<RegitserModel> postModel;

  @override
  void initState() {
    super.initState();
    mainTextFuture = ApiService.getTextMain(widget.postId);
    title = TextEditingController(text: widget.title);
    //mainText = TextEditingController(text: mainTextFuture);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 30,
        title: const Text('글쓰기'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
                onPressed: () async {
                  FutureBuilder(
                    future: ApiService.deletePost(widget.postId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        Fluttertoast.showToast(msg: 'Error');
                      }
                      return const Center(
                        child: CircularProgressIndicator(), //로딩중 동그라미 그림
                      );
                    },
                  );

                  if (context.mounted) {
                    Fluttertoast.showToast(msg: '삭제되었습니다.');
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  '삭제하기',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                )),
          )
        ],
      ),
      floatingActionButton: SizedBox(
        width: 80,
        child: FittedBox(
          child: FloatingActionButton.extended(
            onPressed: () async {
              var post = await ApiService.reviseWrite(
                  title.text, mainText.text, widget.postId);

              if (formData != null) {
                await ApiService.patchUserProfileImage(formData, post.id);
              }
              if (context.mounted) Navigator.pop(context);
            },
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            label: const Text(
              '수정완료',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: openImages,
          ),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(
                  hintText: '제목',
                ),
                style: const TextStyle(fontSize: 20),
              ),
              FutureBuilder(
                future: mainTextFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    mainText =
                        TextEditingController(text: snapshot.data!.textMain);
                    return TextField(
                      controller: mainText,
                      decoration: const InputDecoration(
                        hintText: '내용을 입력하세요',
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      maxLines: 20,
                    );
                  }
                  return const Text("...");
                },
              ),
              const Divider(),
              const Text("Picked Files:"),
              const Divider(),
              imagefiles != null
                  ? Wrap(
                      children: imagefiles!.map((imageone) {
                        return Card(
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.file(File(imageone.path)),
                          ),
                        );
                      }).toList(),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
