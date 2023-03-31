import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreen();
}

class _TestScreen extends State<TestScreen> {
  var pwdWidgets = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("data")),
      body: SingleChildScrollView(
          child: Column(
        children: pwdWidgets,
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              pwdWidgets.add(Row(
                children: const [Text("data")],
              ));
            });
          },
          tooltip: 'Send message',
          child: const Icon(Icons.send)),
    );
  }
}
