import 'package:flutter/material.dart';
import 'package:flutter_board/services/findAllChatRooms_service.dart';

class ChatRoomWidget extends StatelessWidget {
  const ChatRoomWidget({
    super.key,
    required this.post,
  });

  final ChatRoomDataParse post;

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
                      post.name,
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
                  Text(post.count.toString()),
                ]),
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
