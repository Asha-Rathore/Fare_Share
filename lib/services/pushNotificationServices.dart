import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Firebase_Messaging extends StatefulWidget {
  const Firebase_Messaging({Key? key}) : super(key: key);

  @override
  State<Firebase_Messaging> createState() => _Firebase_MessagingState();
}

class _Firebase_MessagingState extends State<Firebase_Messaging> {
  late FirebaseMessaging _firebaseMessaging;
  @override
  void initState() {
    configureCallbacks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  void configureCallbacks() {}
}
