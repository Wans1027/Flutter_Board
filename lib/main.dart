import 'package:flutter/material.dart';
import 'package:flutter_board/screen/login_screen.dart';

void main() {
  //ApiService().createAlbum('newUser02', '1515');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LoginScreen());
  }
}
