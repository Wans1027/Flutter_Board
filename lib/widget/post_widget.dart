import 'package:flutter/material.dart';
import 'package:flutter_board/screen/detail_screen.dart';

import '../model/mainboard_model.dart';

class Post extends StatelessWidget {
  const Post({
    super.key,
    required this.post,
  });

  final BoardDataParse post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 0),
        decoration: const BoxDecoration(
          //border: Border.all(color: Colors.green, width: 3),
          border: Border(bottom: BorderSide(color: Colors.green)),
          //borderRadius: BorderRadius.circular(20),
          //color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.thumb_up_outlined,
                        color: Colors.red,
                        size: 11,
                      ),
                      Text(
                        "${post.likes}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${post.createdDate.substring(11)} 작성자:${post.writer}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
