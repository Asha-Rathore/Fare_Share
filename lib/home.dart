import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:travelapp/Screens/available_ride_sharing_screen.dart';
import 'package:travelapp/Screens/event_seat_screen.dart';
import 'package:travelapp/Screens/find_driver_event_screen.dart';
import 'package:travelapp/Screens/find_driver_intercity_screen.dart';
import 'package:travelapp/services/local_push_notification.dart';
import 'Screens/find_driver_screen.dart';

import 'Utils/constants.dart';
import 'reserveseat.dart';

//import 'intercity.dart';
//import 'event.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen(
      (message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        print("FirebaseMessaging.onMessage.listen 44444444444");
        if (notification != null && android != null) {
          LocalNotificationService.createanddisplaynotification(message);
          print(message.notification!.title);
        }
      },
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      //backgroundColor: Color(0xFFC1C8E4),
      body: Container(
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(colors: [
        //   Color(0xFF5c8ad6),
        //   Color(0xFFebe1e6),
        //   Color(0xFF141414)
        // ], begin: Alignment.topRight, end: Alignment.bottomLeft)
        // ),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0),
            ),
            SizedBox(height: 25.0),
            Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Row(
                  children: [
                    Text(
                      "FARE SHARE",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 40.0),
            Container(
              height: MediaQuery.of(context).size.height - 185.0,
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage("$imgpath/carbackground.png"),
                //   fit: BoxFit.cover,
                //   opacity: 0.6
                // ),
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
              ),
              child: ListView(
                primary: false,
                padding: EdgeInsets.only(left: 25.0, right: 20.0),
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 45.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 300.0,
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //========================= Daily Rides =================
                                SizedBox(height: 30.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomemapPage()
                                                    //  PolyLinePointPage()
                                                    //MapSample(),
                                                    ),
                                              );
                                            },
                                            child: Container(
                                              height: 170.0,
                                              width: 137.0,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            Colors.black38,
                                                            BlendMode.darken),
                                                    image: AssetImage(
                                                        "$imgpath/dr.jpg"),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                      Icons.drive_eta_rounded,
                                                      color: Colors.white,
                                                      size: 40.0,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      "Daily Rides",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 20.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      maxLines: 2,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        //========================= Sharing =================
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Container(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AvailableRidePage(),
                                                  // PolyLinePointPage(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 170.0,
                                              width: 137.0,
                                              decoration: BoxDecoration(
                                                  // color: Color(0xFFC1C8E4),
                                                  image: DecorationImage(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            Colors.black38,
                                                            BlendMode.darken),
                                                    image: AssetImage(
                                                        "$imgpath/share.jpg"),
                                                    fit: BoxFit.cover,
                                                    //  opacity: 0.6
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                      Icons.group_rounded,
                                                      color: Colors.white,
                                                      size: 40.0,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Text(
                                                      "Sharing",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      maxLines: 2,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //========================= Inter-city =================
                                    SizedBox(width: 10.0),
                                    Column(
                                      children: [
                                        Container(
                                          child: InkWell(
                                            onTap: () {
                                              print("event tabed");
                                              //FindDriverInterCityPage
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FindDriverInterCityPage(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 170.0,
                                              width: 137.0,
                                              decoration: BoxDecoration(
                                                  // color: Color(0xFFC1C8E4),
                                                  image: DecorationImage(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            Colors.black38,
                                                            BlendMode.darken),
                                                    image: AssetImage(
                                                        "$imgpath/city.jpg"),
                                                    fit: BoxFit.cover,
                                                    // opacity: 0.6
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Icon(
                                                      Icons
                                                          .location_city_rounded,
                                                      color: Colors.white,
                                                      size: 40.0,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Inter-city",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      maxLines: 2,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        //========================= Picnic =================
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Container(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                    FindDriverEventPage(),
                                                      //EventsReserveSeatsPage(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 170.0,
                                              width: 137.0,
                                              decoration: BoxDecoration(

                                                  // color: Color(0xFFC1C8E4),
                                                  image: DecorationImage(
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            Colors.black38,
                                                            BlendMode.darken),
                                                    image: AssetImage(
                                                        "$imgpath/picnic.jpg"),
                                                    fit: BoxFit.cover,
                                                    //  opacity: 0.6
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Icon(
                                                      Icons.event_available,
                                                      color: Colors.white,
                                                      size: 40.0,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Event",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                      textAlign: TextAlign.left,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      maxLines: 2,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
