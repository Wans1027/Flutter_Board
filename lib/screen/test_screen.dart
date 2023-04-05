import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreen();
}

class _TestScreen extends State<TestScreen> {
  var pwdWidgets = <Widget>[];
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("data")),
      body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: pwdWidgets,
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              pwdWidgets.add(chat());
              scrollJumpToBottom();
            });
          },
          tooltip: 'Send message',
          child: const Icon(Icons.send)),
    );
  }

  void scrollJumpToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  Row chat() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(9),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.amber),

          //color: Colors.amber,
          child: const Text("dataaaaaaaaaaa"),
        )
      ],
    );
  }
}
