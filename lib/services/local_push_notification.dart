import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  // static final FlutterLocalNotificationsPlugin
  //     _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );
    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? id) async {
        print("onSelectNotification");
        if (id!.isNotEmpty) {
          print("Router Value1234 $id");

          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => DemoScreen(
          //       id: id,
          //     ),
          //   ),
          // );

        }
      },
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "mychanel",
          "mychanelappchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        //payload: message.data['command'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
  // static void initialize() {
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //           android: AndroidInitializationSettings("@mipmap/ic_launcher"));
  //   _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  // static void display(RemoteMessage message) async{
  //   try {
  //     print("In Notification method");
  //     // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
  //     Random random = new Random();
  //     int id = random.nextInt(1000);
  //     final NotificationDetails notificationDetails = NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           "mychanel",
  //           "my chanel",
  //           importance: Importance.max,
  //           priority: Priority.high,
  //         )

  //     );
  //     print("my id is ${id.toString()}");
  //     await _flutterLocalNotificationsPlugin.show(

  //       id,
  //       message.notification!.title,
  //       message.notification!.title,
  //       notificationDetails,);
  //   } on Exception catch (e) {
  //     print('Error>>>$e');
  //   }
  // }
}
