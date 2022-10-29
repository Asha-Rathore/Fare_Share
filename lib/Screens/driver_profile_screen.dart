import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:travelapp/Driver/driver_main_page.dart';
import 'package:travelapp/Driver/driver_main_page1.dart';
import 'package:travelapp/Screens/main_screen.dart';
import 'package:travelapp/Screens/update_ride_info.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/services/database_helper.dart';
import 'package:travelapp/services/local_push_notification.dart';
import 'package:travelapp/widgets/custome_button.dart';

class DriverProfileScreen extends StatefulWidget {
  String? userid;
  bool isIntercityride;
  bool isEventRide;
  String? icityid;
  DriverProfileScreen(
      {Key? key,
      this.userid,
      this.isIntercityride = false,
      this.isEventRide = false,
      this.icityid})
      : super(key: key);

  @override
  _DriverProfileScreenState createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  double _originLatitude = 0.0, _originLongitude = 0.0;
  double _destLatitude = 0.0, _destLongitude = 0.0;
  String totalPrice = "0";
  String from = "";
  String destination = "";
  late bool? isRidecancel;
  String uId = "";
  var locationMessage = '';
  String? latitude;
  String? longitude;
  String? eml;

  @override
  void initState() {
    print("init state call ${widget.userid}");
    widget.userid != null ? getdailyrideData(widget.userid) : null;
    widget.isIntercityride
        ? getInterCityRide(widget.userid, widget.icityid)
        : null;
    widget.isEventRide ? getEventRide(widget.userid, widget.icityid) : null;
    getStringValuesSF();
    FirebaseMessaging.onMessage.listen(
      (message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          LocalNotificationService.createanddisplaynotification(message);
          print(message.notification!.title);
          if (message.data['command'] != null) {
            getdailyrideData(message.data['command']);
          } else if (message.data['command1'] != null) {
            getInterCityRide(message.data['command1'], message.data['icityid']);
          } else if (message.data['commandevent'] != null) {
            getEventRide(message.data['commandevent'], message.data['eventid']);
          }
        }
      },
    );
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method
/*
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );
    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
*/
    super.initState();
  }

  void getdailyrideData(String? rideId) {
    FirebaseFirestore.instance
        .collection('DailyRides')
        .doc(rideId)
        .get()
        .then((value) {
      //'value' is the instance of 'DocumentSnapshot'
      //'value.data()' contains all the data inside a document in the form of 'dictionary'
      var fields = value.data();

      //Using 'setState' to update the user's data inside the app
      //firstName, lastName and title are 'initialised variables'
      setState(() {
        from = fields!['from'];
        destination = fields['destination'];
        isRidecancel = fields['flag'];
        uId = fields['userid'];
        totalPrice = fields['totalPrice'].toString();
        getlatLonFrom(sourceLoc: fields['from']);
        getlatLonTo(destinationLoc: fields['destination']);
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "New Ride Request",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 2.0),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 5.0),
                  Flexible(
                    child: Text(
                      fields!['from'],
                      // message.notification!.body![0].toString(),
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Icon(Icons.location_city),
                  SizedBox(width: 5.0),
                  Flexible(
                    child: Text(
                      fields['destination'],
                      // message.notification!.body![1].toString(),
                      //"Destination Location Addressdsf ajlfsla faslk f;lasflsaf asfl;saf;",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Divider(thickness: 2.0),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomeButton(
                  text: "ACCEPT",
                  onTap: () {
                    if (_originLatitude == 0.0 && _destLongitude == 0.0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Somethin Wrong"),
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DriverMapPage(
                                  originLatitude: _originLatitude,
                                  originLongitude: _originLongitude,
                                  destLatitude: _destLatitude,
                                  destLongitude: _destLongitude,
                                  source: from,
                                  destination: destination,
                                  totalPrice: totalPrice,
                                )),
                      );
                    }
                  },
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomeButton(
                  text: "CANCEL",
                  onTap: () {
                    if (isRidecancel == true) {
                      FirebaseFirestore.instance
                          .collection('DailyRides')
                          .doc(uId)
                          .update({'flag': false});
                      Future.delayed(Duration(seconds: 1), () {
                        FirebaseFirestore.instance
                            .collection('DailyRides')
                            .doc(uId)
                            .delete();
                      });
                      Navigator.of(context).pop();
                    } else {
                      print("Already ride cancelled ");
                    }
                  },
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void getInterCityRide(String? rideId, String? intercityid) {
    FirebaseFirestore.instance
        .collection('InterCity')
        .doc(rideId)
        .collection('InterCityDataUsers')
        .doc(intercityid)
        .get()
        .then((value) {
      //'value' is the instance of 'DocumentSnapshot'
      //'value.data()' contains all the data inside a document in the form of 'dictionary'
      var fields = value.data();

      //Using 'setState' to update the user's data inside the app
      //firstName, lastName and title are 'initialised variables'
      setState(() {
        from = fields!['pickUpLocation'];
        destination = fields['dropOffLoacation'];
        isRidecancel = fields['flag'];
        uId = fields['email'];
        totalPrice = fields['totalPrice'].toString();
        getlatLonFrom(sourceLoc: fields['pickUpLocation']);
        getlatLonTo(destinationLoc: fields['dropOffLoacation']);
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "New Ride Request",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 2.0),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 5.0),
                  Flexible(
                    child: Text(
                      fields!['pickUpLocation'],
                      // message.notification!.body![0].toString(),
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Icon(Icons.location_city),
                  SizedBox(width: 5.0),
                  Flexible(
                    child: Text(
                      fields['dropOffLoacation'],
                      // message.notification!.body![1].toString(),
                      //"Destination Location Addressdsf ajlfsla faslk f;lasflsaf asfl;saf;",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Divider(thickness: 2.0),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomeButton(
                  text: "ACCEPT",
                  onTap: () {
                    if (_originLatitude == 0.0 && _destLongitude == 0.0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Somethin Wrong"),
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DriverMapPage(
                                  originLatitude: _originLatitude,
                                  originLongitude: _originLongitude,
                                  destLatitude: _destLatitude,
                                  destLongitude: _destLongitude,
                                  source: from,
                                  destination: destination,
                                  totalPrice: totalPrice,
                                )),
                      );
                    }
                  },
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomeButton(
                  text: "CANCEL",
                  onTap: () {
                    if (isRidecancel == true) {
                      FirebaseFirestore.instance
                          .collection('InterCity')
                          .doc(rideId)
                          .collection('InterCityDataUsers')
                          .doc(intercityid)
                          .update({'flag': false});
                      Future.delayed(Duration(seconds: 1), () {
                        FirebaseFirestore.instance
                            .collection('InterCity')
                            .doc(rideId)
                            .collection('InterCityDataUsers')
                            .doc(intercityid)
                            .delete();
                      });
                      setState(() {
                        _originLatitude = 0.0;
                        _destLongitude = 0.0;
                      });
                      Navigator.of(context).pop();
                    } else {
                      print("Already ride cancelled ");
                    }
                  },
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void getEventRide(String? rideId, String? intercityid) {
    FirebaseFirestore.instance
        .collection('Events')
        .doc(rideId)
        .collection('EventsDataUsers')
        .doc(intercityid)
        .get()
        .then((value) {
      //'value' is the instance of 'DocumentSnapshot'
      //'value.data()' contains all the data inside a document in the form of 'dictionary'
      var fields = value.data();

      //Using 'setState' to update the user's data inside the app
      //firstName, lastName and title are 'initialised variables'
      setState(() {
        from = fields!['pickUpLocation'];
        destination = fields['dropOffLoacation'];
        isRidecancel = fields['flag'];
        uId = fields['email'];
        totalPrice = fields['totalPrice'].toString();
        getlatLonFrom(sourceLoc: fields['pickUpLocation']);
        getlatLonTo(destinationLoc: fields['dropOffLoacation']);
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "New Ride Request",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Divider(thickness: 2.0),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 5.0),
                  Flexible(
                    child: Text(
                      fields!['pickUpLocation'],
                      // message.notification!.body![0].toString(),
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Icon(Icons.location_city),
                  SizedBox(width: 5.0),
                  Flexible(
                    child: Text(
                      fields['dropOffLoacation'],
                      // message.notification!.body![1].toString(),
                      //"Destination Location Addressdsf ajlfsla faslk f;lasflsaf asfl;saf;",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Divider(thickness: 2.0),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomeButton(
                  text: "ACCEPT",
                  onTap: () {
                    if (_originLatitude == 0.0 && _destLongitude == 0.0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Somethin Wrong"),
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DriverMapPage(
                                  originLatitude: _originLatitude,
                                  originLongitude: _originLongitude,
                                  destLatitude: _destLatitude,
                                  destLongitude: _destLongitude,
                                  source: from,
                                  destination: destination,
                                  totalPrice: totalPrice,
                                )),
                      );
                    }
                  },
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomeButton(
                  text: "CANCEL",
                  onTap: () {
                    if (isRidecancel == true) {
                      FirebaseFirestore.instance
                          .collection('Events')
                          .doc(rideId)
                          .collection('EventsDataUsers')
                          .doc(intercityid)
                          .update({'flag': false});
                      Future.delayed(Duration(seconds: 1), () {
                        FirebaseFirestore.instance
                            .collection('Events')
                            .doc(rideId)
                            .collection('EventsDataUsers')
                            .doc(intercityid)
                            .delete();
                      });
                      setState(() {
                        _originLatitude = 0.0;
                        _destLongitude = 0.0;
                      });
                      Navigator.of(context).pop();
                    } else {
                      print("Already ride cancelled ");
                    }
                  },
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  getlatLonFrom({String? sourceLoc}) async {
    try {
      List<Location> locations = await locationFromAddress(sourceLoc ?? "");

      setState(() {
        _originLatitude = locations[0].latitude;
        _originLongitude = locations[0].longitude;
      });
    } catch (e) {
      print(e);
    }
  }

  getlatLonTo({String? destinationLoc}) async {
    try {
      List<Location> locations =
          await locationFromAddress(destinationLoc ?? "");
      setState(() {
        _destLatitude = locations[0].latitude;
        _destLongitude = locations[0].longitude;
      });
    } catch (e) {
      print(e);
    }
  }

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;

    // passing this to latitude and longitude strings

    setState(() {
      latitude = "$lat";
      longitude = "$long";
      locationMessage = "Latitude: $lat and Longitude: $long";
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _checkbox = false;

    final double btnmargsize = MediaQuery.of(context).size.width * 0.09;
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[800],
        title: new Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        toolbarHeight: 70.0,
        elevation: 5.0,
      ),
      drawer: SafeArea(
        child: new Drawer(
          child: StreamBuilder<QuerySnapshot>(
            stream: Database.readDriverData(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError && snapshot.data == null) {
                return Text('Something went wrong');
              } else if (snapshot.hasData || snapshot.data != null) {
                print(snapshot.data?.docs.length);
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data!.docs[index]['Email'] == eml) {
                        return Column(
                          children: [
                            Container(
                              height: 200,
                              width: sizeWidth(context),
                              color: Colors.grey[800],
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Driver",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['name'],
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white),
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['Email'],
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  new ListTile(
                                    title: new Text(
                                      'Sign out',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                    trailing: new Icon(Icons.close),
                                    //onTap: ()=>Navigator.of(context).pop(),
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await //prefs?.clear();
                                          prefs.clear();
                                      await prefs.remove('driveremail');
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  MainScreen()));
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      } else
                        return SizedBox();
                    });
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
      body: Container(
        //carmech1
        height: sizeheight(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.darken),
            image: AssetImage('$imgpath/carbackground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50.0),
            RichText(
              text: TextSpan(
                text: 'Welcome to ',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Fare Share ',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                      ))
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              //color: Colors.amber,
              //height: 150,
              width: sizeWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Driver",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      height: 40,
                      width: 40,
                      child: Image.asset(
                        "$imgpath/car.png",
                        color: Colors.black,
                        height: 40,
                        width: 40,
                        //  cacheColorFilter: true,
                      )),
                ],
              ),
            ),

            SizedBox(height: 20),
            SizedBox(
              height: 40,
              width: 170,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => UpdateRideInfo()
                    )
                  );
                },
                child: Text("Update Ride Info"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
                ),
              ),
            ),

            //SizedBox(height: 10.0),
            // Text(
            //   'Driver at your spot',
            //   style: TextStyle(color: Colors.black),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // Divider(
            //   height: 5,
            //   thickness: 1,
            //   color: Colors.black,
            // ),

            // SizedBox(height: 30.0),

            // SizedBox(height: 10.0),
            //Login Buttons
            // Container(
            //     width: sizeWidth(context),
            //     margin: EdgeInsets.only(left: btnmargsize, right: btnmargsize),
            //     height: 45,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(30.0)),
            //     ),
            //     child: ElevatedButton(
            //       child: Text(
            //         "Find Trips",
            //         style: TextStyle(
            //           fontSize: 20.0,
            //           fontWeight: FontWeight.w300,
            //           color: Colors.white,
            //           fontFamily: 'Montserrat',
            //         ),
            //       ),
            //       onPressed: () {
            //         if (_originLatitude == 0.0 && _destLongitude == 0.0) {
            //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //             content: Text("Something Wrong"),
            //             duration: Duration(seconds: 2),
            //           ));
            //         } else {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => DriverMapPage(
            //                 originLatitude: _originLatitude,
            //                 originLongitude: _originLongitude,
            //                 destLatitude: _destLatitude,
            //                 destLongitude: _destLongitude,
            //                 source: from,
            //                 destination: destination,
            //                 totalPrice: totalPrice,
            //               ),
            //             ),
            //           );
            //         }
            //       },
            //       style: ElevatedButton.styleFrom(
            //         primary: Colors.grey[800],
            //         textStyle:
            //             TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //         shape: new RoundedRectangleBorder(
            //           borderRadius: new BorderRadius.circular(10.0),
            //         ),
            //       ),
            //     )),

            // SizedBox(
            //   height: 50,
            // ),
            // Divider(
            //   height: 5,
            //   thickness: 1,
            //   color: Colors.black,
            // ),
          ],
        ),
      ),
    );
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    var stringValue = prefs.getString('driveremail');
    setState(() {
      eml = stringValue;
    });
    // return stringValue;
  }
}
