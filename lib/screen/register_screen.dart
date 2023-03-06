import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_board/screen/login_screen.dart';
import 'package:flutter_board/services/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/register_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late Future<RegitserModel> regModel;
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: username,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'UserName',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            CupertinoButton(
                child: const Text(
                  "회원가입",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  regModel = await ApiService.registMember(
                          username.text, password.text)
                      .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          )))
                      .catchError((onError) {
                    Fluttertoast.showToast(
                      msg: onError.toString(),
                      gravity: ToastGravity.TOP,
                      backgroundColor: Colors.redAccent,
                      fontSize: 20,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  });
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const LoginScreen(),
                  //     ));
                })
          ],
        ),
      ),
    );
  }
}
