import 'package:flutter/material.dart';

import '../model/mainboard_model.dart';

class Post extends StatelessWidget {
  const Post({
    super.key,
    required this.post,
  });

  final BoardDataParse post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: const BoxDecoration(
        //border: Border.all(color: Colors.green, width: 3),
        border: Border(bottom: BorderSide(color: Colors.black)),
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
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    post.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 5,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "작성자:${post.writer}",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 140.0),
                    ),
                    Text(
                      post.createdDate.substring(0, 16),
                      style: const TextStyle(
                        color: Colors.black54,
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
    );
  }
}
