import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

/// What I do this Screen????
/// 앱을 키면
/// FCM Token이 내부 저장소에 있는지 확인을 하고
/// 없다면 토큰을 FCM서버에 요청, isNew를 True로 설정
/// 토큰을 static으로 저장하고
///
///
class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
