import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/rideconfirmed.dart';
import 'package:travelapp/services/database_helper.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:number_inc_dec/number_inc_dec.dart';

class SharingPayments extends StatefulWidget {
  final String origin;
  final String destination;
  final num? totalDistance;
  final num? totalPrice;
  final num? passengers;

  SharingPayments(
      {required this.origin,
      required this.destination,
      this.totalDistance,
      this.totalPrice,
      this.passengers
      });
  //const PaymentsPage({ Key? key }) : super(key: key);

  @override
  _SharingPaymentsState createState() => _SharingPaymentsState();
}

class _SharingPaymentsState extends State<SharingPayments> {
  //snackbar message
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
    ));
  }
  //DateTime selectedDate = DateTime.now();

  var time;
  var now;
  late FlutterLocalNotificationsPlugin localNotif;
  @override
  void initState() {
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('logo');
    var iOSinit = new IOSInitializationSettings();
    var initSettings =
        new InitializationSettings(android: androidInitilize, iOS: iOSinit);
    localNotif = new FlutterLocalNotificationsPlugin();
    localNotif.initialize(initSettings);
  }

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
        //shrinkWrap: true,
        children: [
          
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 10.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                //height: MediaQuery.of(context).size.height - 145.0,
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
                      Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                          child: Text(
                            "No Of Passengers",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.left,
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                          child: Text(
                      
                            "${widget.passengers}",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18.0,
                      
                              ),
                              textAlign: TextAlign.left,
                            )
                        ),
                      
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
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0, left: 70.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              now = DateTime.now();
                              time = DateFormat('dd-MM-yyyy').format(now);
                            });
                      
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            //Return String
                            var userEmail = prefs.getString('useremail');
                      
                            // add data in db of dailyrides
                            await Database.addSharing(
                              from: widget.origin,
                              destination: widget.destination,
                              totalDistance: widget.totalDistance,
                              totalPrice: widget.totalPrice,
                              dateTime: now,
                              email: userEmail,
                              nopassengers: widget.passengers
                            );
                            _showNotification();
                            // _showMessageInScaffold("Ride Conform Successfully");
                            //add data end
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RideConfirmed()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 17.0, bottom: 17.0, left: 40.0, right: 40.0),
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
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[800]),
                          ),
                        ),
                      ),
                    SizedBox(height: 30.0,)
                    ],
                  ),
                ),),
          ),
        ],
      ),
    );
  }
}
