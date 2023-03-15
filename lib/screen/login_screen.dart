import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_board/screen/register_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_board/screen/home_screen.dart';

import '../model/register_model.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Future<RegitserModel>? loginModel;
  final username1 = TextEditingController();
  final password1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: username1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'UserName',
                labelStyle: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: password1,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                labelStyle: TextStyle(fontSize: 30),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  onPressed: () async {
                    loginModel = await ApiService.loginMember(
                            username1.text, password1.text)
                        .then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                      Fluttertoast.showToast(msg: "로그인성공");
                    }).catchError((onError) {
                      print(onError);
                      Fluttertoast.showToast(
                        msg: onError.toString(),
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.redAccent,
                        fontSize: 20,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    });

                    //buildFutureBuilder();
                  },
                  child: const Text(
                    "로그인",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                CupertinoButton(
                  child: const Text(
                    "회원가입",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                )
              ],
            ),
            // Row(
            //   children: [
            //     FutureBuilder(
            //       future: loginModel = ApiService.loginMember('user1', '1234')
            //           .catchError((onError) {
            //         print(onError);
            //       }),
            //       builder: (context, snapshot) {
            //         if (snapshot.hasData) {
            //           Future.delayed(const Duration(seconds: 1), () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => HomeScreen(),
            //                 ));
            //           });
            //           //return const Text("Success");
            //         } else if (snapshot.hasError) {
            //           return const Text("fail");
            //         }
            //         return const CircularProgressIndicator();
            //       },
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
