// ignore: file_names
import 'dart:io';
import 'package:flutter_board/model/register_model.dart';
import 'package:flutter_board/screen/home_screen.dart';
import 'package:flutter_board/services/api_service.dart';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WritePost extends StatefulWidget {
  const WritePost({super.key});

  @override
  State<WritePost> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<WritePost> {
  final title = TextEditingController();
  final mainText = TextEditingController();

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
                  var post =
                      await ApiService.postWrite(title.text, mainText.text);

                  if (formData != null) {
                    await ApiService.patchUserProfileImage(formData, post.id);
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  '완료',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                )),
          )
        ],
      ),
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
              TextField(
                controller: mainText,
                decoration: const InputDecoration(
                  hintText: '내용을 입력하세요',
                ),
                style: const TextStyle(
                  fontSize: 18,
                ),
                maxLines: 20,
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
