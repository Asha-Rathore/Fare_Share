import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/bottomnav.dart';
import 'package:travelapp/rideconfirmed.dart';
import 'package:travelapp/services/database_helper.dart';

import 'package:http/http.dart' as http;
import 'package:travelapp/services/local_push_notification.dart';
import 'package:travelapp/widgets/custome_snackbar.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:number_inc_dec/number_inc_dec.dart';

class PaymentsPage extends StatefulWidget {
  final String origin;
  final String destination;
  final num? totalDistance;
  final num? totalPrice;
  final String name;
  final String phone;
  final String service;
  //final String? token;

  PaymentsPage({
    required this.origin,
    required this.destination,
    this.totalDistance,
    this.totalPrice,
    required this.name,
    required this.phone,
    required this.service,
    //this.token,
  });
  //const PaymentsPage({ Key? key }) : super(key: key);

  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  //snackbar message
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool flag = false;

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
    ));
  }
  //DateTime selectedDate = DateTime.now();

  // storeNotificationToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   FirebaseFirestore.instance
  //       .collection('UsersData')
  //       .doc(FirebaseAuth.instance.currentUser!.email)
  //       .set({'token': token}, SetOptions(merge: true));
  //   print("Token created");
  // }

  var time;
  var now;
  late FlutterLocalNotificationsPlugin localNotif;
  @override
  void initState() {
    print("Device token payment ");
    //print(widget.token);
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('logo');
    var iOSinit = new IOSInitializationSettings();
    var initSettings =
        new InitializationSettings(android: androidInitilize, iOS: iOSinit);
    localNotif = new FlutterLocalNotificationsPlugin();
    localNotif.initialize(initSettings);
    FirebaseMessaging.onMessage.listen((event) {
      //RLocalNotificationService.display(event);
    });
    // storeNotificationToken();
  }

/*
  sendNotification(String title, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title
    };
    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAJ2uUws4:APA91bHdJ_E4iIyxqoQ2LXIJxlAps26gp9CZs-U2fPm_K9fGrXPH7xF19eHsDuErmdqbVGYiQccodXurNEJy6lDT_Qd9N1tiD9xlbKZ2j3qTD9L_BADFR269XZadwY0ZS9AcBpn7Q_Lo'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': 'Someone sent you trip request'
                },
                'priority': 'high',
                'data': data,
                'to': '$token'
              }));

      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");
      } else {
        print("Error");
      }
    } catch (e) {
      print(e);
    }
  }
*/
  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Hello", "The Travel App",
        importance: Importance.high);
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotif.show(0, "Ride Confirmed",
        'Your ride has been confirmed on $time', generalNotificationDetails);
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101),
  //       builder: (context, child) {
  //           return Theme(
  //             data: ThemeData.dark().copyWith(
  //               colorScheme: ColorScheme.dark(
  //                   primary: Color(0xFF80CBC4),
  //                   onPrimary: Colors.white,
  //                   surface: Color(0xFF80CBC4),
  //                   onSurface: Colors.black,
  //                   ),
  //               dialogBackgroundColor:Colors.white,
  //             ),
  //             child: child!,
  //           );
  //         },
  //     );
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF21BFBD),
      backgroundColor: Colors.grey[800],

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 10.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BottomNav(),
                                );
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Row(
                children: [
                  Text(
                    "Payments",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 30.0,
                    ),
                  )
                ],
              )),
          SizedBox(height: 20.0),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Text(
                            "Source",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Text(
                            "${widget.origin}",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.left,
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Text(
                            "Destination",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Text(
                            " ${widget.destination}",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.left,
                          )),
                      // Padding(
                      //     padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      //     child: Text(
                      //       "Total Time",
                      //         style: TextStyle(
                      //           fontFamily: 'Montserrat',
                      //           fontSize: 25.0,
                      //           fontWeight: FontWeight.bold
                      //         ),
                      //         textAlign: TextAlign.left,
                      //       )
                      //   ),
                      //   Padding(
                      //     padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      //     child: Text(

                      //       "${widget.origin}",
                      //         style: TextStyle(
                      //           fontFamily: 'Montserrat',
                      //           fontSize: 18.0,

                      //         ),
                      //         textAlign: TextAlign.left,
                      //       )
                      //   ),

                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Text(
                            "Total Distance",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Text(
                            '${widget.totalDistance.toString()} KM',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.left,
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Text(
                            "Total Payments",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Text(
                            '${widget.totalPrice.toString()} PKR',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.left,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Text(
                            "Driver Info.",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          )),
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.grey[800],
                          size: 30,
                        ),
                        title: Text(
                          "${widget.name}",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.car_rental,
                          color: Colors.grey[800],
                          size: 30,
                        ),
                        title: Text(
                          "${widget.service}",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        //Text("Address"),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.phone_rounded,
                          color: Colors.grey[800],
                          size: 30,
                        ),
                        title: Text(
                          "${widget.phone}",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        //Text("Address"),
                      ),
                      SizedBox(height: 8.0),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                now = DateTime.now();
                                time = DateFormat('dd-MM-yyyy').format(now);
                                flag = true;
                              });
                              flag = true;
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              //Return String
                              var userEmail = prefs.getString('useremail');

                              // add data in db of dailyrides
                              await Database.addDailyRide(
                                  from: widget.origin,
                                  destination: widget.destination,
                                  totalDistance: widget.totalDistance,
                                  totalPrice: widget.totalPrice,
                                  dateTime: now,
                                  driverid: widget.phone,
                                  email: userEmail,
                                  userid: userEmail,
                                  flag: flag);
                              CustomSnacksBar.showSnackBar(
                                  context, "Request Send Successfully");
                              // _showMessageInScaffold("Request Send Successfully");
                              // String? token =
                              //     "cBVGGIEkSseAn_rpZJvSGI:APA91bF4Znmpz7mRuRdwJjNLlpg1pzvM19E25-8Wv8phbNb_qgeqjE7F6rxoO-BbjGOe4AQ7ikNF52QMCpDV5jtCFcL0Duqoq7L1IIooUHecsYzu6jcSNlgu6pMtot0jA4tSoMBYZvGY";
                              _showNotification();
                              // FirebaseFirestore.instance
                              //     .collection('UsersData')
                              //     .doc(FirebaseAuth.instance.currentUser!.email)
                              //     .set({}, SetOptions(merge: true));
                              // sendNotification('Trip', token!);
                              // _showMessageInScaffold("Ride Conform Successfully");
                              //add data end
                              Future.delayed(Duration(seconds: 5), () {
                                // 5s over, navigate to a new page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RideConfirmed()),
                                );
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 17.0,
                                  bottom: 17.0,
                                  left: 40.0,
                                  right: 40.0),
                              child: Text(
                                'Confirm Ride',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey[800]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
