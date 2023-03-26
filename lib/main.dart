import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_board/screen/login_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   //ApiService().createAlbum('newUser02', '1515');
//   runApp(const MyApp());
// }
void main() async {
  await bindingAndGetToken();
  runApp(const MyApp());
}

Future<void> bindingAndGetToken() async {
  FirebaseMessaging fbMsg = await bindingFCM(); //binding
  final prefs = await SharedPreferences.getInstance(); //내부저장소 접근

  if (prefs.getString("FCMTOKEN") == null) {
    //데이터가 존재하지 않는다면
    //토큰가져오기
    String? fcmToken =
        await fbMsg.getToken(vapidKey: "BGRA_GV..........keyvalue");
    //TODO : 서버에 해당 토큰을 저장하는 로직 구현
    print("token-------------------------: $fcmToken");
    //FCM 토큰은 사용자가 앱을 삭제, 재설치 및 데이터제거를 하게되면 기존의 토큰은 효력이 없고 새로운 토큰이 발금된다.
    fbMsg.onTokenRefresh.listen((nToken) {
      //TODO : 서버에 해당 토큰을 저장하는 로직 구현
    });

    // 플랫폼 확인후 권한요청 및 Flutter Local Notification Plugin 설정
    await notificationPluginConfig(fbMsg);
    prefs.setString('FCMTOKEN', fcmToken!); //내부 데이터 생성
  }
  print("내부저장소FCMTOKEN: ${prefs.getString("FCMTOKEN")}");
}

Future<void> notificationPluginConfig(FirebaseMessaging fbMsg) async {
  // 플랫폼 확인후 권한요청 및 Flutter Local Notification Plugin 설정
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel? androidNotificationChannel;
  if (Platform.isIOS) {
    //await reqIOSPermission(fbMsg);
  } else if (Platform.isAndroid) {
    //Android 8 (API 26) 이상부터는 채널설정이 필수.
    androidNotificationChannel = const AndroidNotificationChannel(
      'important_channel', // id
      'Important_Notifications', // name
      '중요도가 높은 알림을 위한 채널.',
      // description
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }
  //Background Handling 백그라운드 메세지 핸들링
  FirebaseMessaging.onBackgroundMessage(fbMsgBackgroundHandler);
  //Foreground Handling 포어그라운드 메세지 핸들링
  FirebaseMessaging.onMessage.listen((message) {
    fbMsgForegroundHandler(
        message, flutterLocalNotificationsPlugin, androidNotificationChannel);
  });
  //Message Click Event Implement
  await setupInteractedMessage(fbMsg);
}

Future<FirebaseMessaging> bindingFCM() async {
  WidgetsFlutterBinding.ensureInitialized(); // 바인딩
  await Firebase.initializeApp();
  FirebaseMessaging fbMsg = FirebaseMessaging.instance;

  return fbMsg;
}

//실행ㅇㅇㅇㅇㅇ
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LoginScreen());
    //return const MaterialApp(home: WritePost());
  }
}

/// iOS 권한을 요청하는 함수
Future reqIOSPermission(FirebaseMessaging fbMsg) async {
  NotificationSettings settings = await fbMsg.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

/// Firebase Background Messaging 핸들러
Future<void> fbMsgBackgroundHandler(RemoteMessage message) async {
  print("[FCM - Background] MESSAGE : ${message.messageId}");
}

/// Firebase Foreground Messaging 핸들러
Future<void> fbMsgForegroundHandler(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    AndroidNotificationChannel? channel) async {
  print('[FCM - Foreground] MESSAGE : ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
    flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id,
            channel.name,
            channel.description,
            icon: '@mipmap/ic_launcher',
          ),
          // iOS: const DarwinNotificationDetails(
          //   badgeNumber: 1,
          //   subtitle: 'the subtitle',
          //   sound: 'slow_spring_board.aiff',
          // ),
        ));
  }
}

/// FCM 메시지 클릭 이벤트 정의
Future<void> setupInteractedMessage(FirebaseMessaging fbMsg) async {
  RemoteMessage? initialMessage = await fbMsg.getInitialMessage();
  // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
  if (initialMessage != null) clickMessageEvent(initialMessage);
  // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
  FirebaseMessaging.onMessageOpenedApp.listen(clickMessageEvent);
}

void clickMessageEvent(RemoteMessage message) {
  //print('message : ${message.notification!.title}');
  //Get.toNamed('/');
}
