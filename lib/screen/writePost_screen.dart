// ignore: file_names
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_board/model/register_model.dart';
import 'package:flutter_board/screen/home_screen.dart';
import 'package:flutter_board/services/api_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class WritePost extends StatefulWidget {
  const WritePost({super.key});

  @override
  State<WritePost> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<WritePost> {
  //final title = TextEditingController();
  final mainText = TextEditingController();

  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  FormData? formData;

  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _mainText = '';

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage(imageQuality: 70);
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        imagefiles = pickedfiles;
        final List<MultipartFile> files = imagefiles!
            .map((img) => MultipartFile.fromFileSync(img.path,
                contentType: MediaType(
                  "image",
                  "jpg",
                )))
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

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  late Future<RegitserModel> postModel;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
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
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      print(_title);
                      var post = await ApiService.postWrite(_title, _mainText);

                      if (formData != null) {
                        await ApiService.patchUserProfileImage(
                            formData, post.id);
                      }
                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ));
                      }
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
                    '완료',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  )),
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BottomAppBar(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              IconButton(
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  size: 35,
                ),
                onPressed: openImages,
              ),
            ],
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  onSaved: (newValue) {
                    setState(() {
                      _title = newValue as String;
                    });
                  },
                  autovalidateMode: AutovalidateMode.always,
                  //controller: title,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '제목을 입력해주세요';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: '제목',
                  ),
                  style: const TextStyle(fontSize: 20),
                ),
                TextFormField(
                  onSaved: (newValue) {
                    setState(() {
                      _mainText = newValue as String;
                    });
                  },
                  autovalidateMode: AutovalidateMode.always,
                  //controller: title,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '내용을 입력해주세요';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: '내용을 입력해주세요',
                  ),
                  maxLines: 20,
                  style: const TextStyle(fontSize: 20),
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
      ),
    );
  }
}
