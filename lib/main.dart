import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travelapp/Screens/driver_profile_screen.dart';
import 'package:travelapp/Screens/finish_trip_screen.dart';
import 'package:travelapp/Screens/splash_screen.dart';
import 'package:travelapp/widgets/custome_snackbar.dart';
import 'blocs/application_bloc.dart';
import 'package:location/location.dart' as loc;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';

//import 'home.dart';
import 'bottomnav.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

import 'services/local_push_notification.dart';

// Future<void> _handlebackgroundMessaging(RemoteMessage message) async {
//   /// Onclick listener
// }
//background services Notification
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void getCurrentLocation() async {
  try {
    var permission = await Geolocator.checkPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await loc.Location().requestService();
      return Future.error('Location services are disabled.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("permission check");
      print(permission);
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    var status = await Permission.locationWhenInUse.serviceStatus.isEnabled;
    //print("location permission");
    // print(status);
    if (status) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // passing this to latitude and longitude strings

    }
  } catch (e) {
    print("catch***************error**********");
  }
}

late AndroidNotificationChannel channel;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
//Permission
  getCurrentLocation();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
//chanel
//  channel = const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       'This channel is used for important notifications.', // description
//       importance: Importance.high,
//     );
  channel = AndroidNotificationChannel(
    'mychanel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications', // description
    importance: Importance.high,
  );
//chanel
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_notification_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // iOS: initializationSettingsIOS,
    // macOS: initializationSettingsMacOS,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  //on tap local notification
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    Map<String, dynamic> _notificationData = {};
    if (payload != null) {
      debugPrint('notification payload: $payload');
      print("paylod************************");
      _notificationData = jsonDecode(payload);
    }
    // selectedNotificationPayload = payload;
    // selectNotificationSubject.add(payload);
  });
//
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  Future<void> setupInteractedMessage() async {
// 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can
    // get notification data in this method
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print(
            "FirebaseMessaging.instance.getInitialMessage-------------------");
        if (message != null) {
          LocalNotificationService.createanddisplaynotification(message);
          print("terminate state 1");
          if (message.data != null) {
            _handleMessage(message);
          } else {
            _handleMessage1(message);
          }
        }
      },
    );

    //background state
    //if you are sending a notification message, and you clicked the notification then the onMessageOpenedApp will be called.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data;
      print('A new onMessageOpenedApp event was published-----------!');
      LocalNotificationService.createanddisplaynotification(message);
/*
So if you don’t have a BuildContext at that point, 
you can register a GlobalKey as the navigatorKey property of your MaterialApp,
 and use it to access your Navigator globally, via GlobalKey.currentState.
*/
      if (message.data != null) {
        _handleMessage(message);
      } else {
        _handleMessage1(message);
      }
    });
  }

  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: 'Montserrat',
          ),
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          //home: FinishTripPage(),
        );
      },
    );
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['command'] != null) {
      navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (_) =>
              DriverProfileScreen(userid: message.data['command'])));
    } else if (message.data['command1'] != null) {
      navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (_) => DriverProfileScreen(
                userid: message.data['command1'],
                isIntercityride: true,
                icityid: message.data['icityid'],
              )));
    }else if(message.data['commandevent'] != null){
  navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (_) => DriverProfileScreen(
                userid: message.data['commandevent'],
                isEventRide: true,
                icityid: message.data['eventid'],
              )));
    }
  }

  void _handleMessage1(RemoteMessage message) {
    navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (_) => BottomNav()));

    print("terminate state end");
  }
}
