import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_board/screen/home_screen.dart';
import 'package:flutter_board/screen/register_screen.dart';
import 'package:flutter_board/services/api_service.dart';

import '../model/register_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Future<RegitserModel> loginModel;
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                    child: const Text(
                      "로그인",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      try {
                        loginModel = ApiService()
                            .loginMember(username.text, password.text);
                        FutureBuilder(
                          future: loginModel,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print(snapshot);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ));
                            }
                            return const Text('...');
                          },
                        );
                      } catch (e) {
                        print(e);
                      }
                    }),
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
                          ));
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
