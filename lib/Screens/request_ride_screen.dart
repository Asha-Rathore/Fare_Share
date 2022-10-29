import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/rideconfirmed.dart';
import 'package:travelapp/services/database_helper.dart';
import 'package:travelapp/widgets/custome_snackbar.dart';

class RequestRide extends StatefulWidget {
  final String? driverName;
  final String? driverCarType;
  final String? driverCarNo;
  String? driverPickupLoc;
  String? driverDropoffLoc;
  final String? driverAC;
  final int? driverseats;
  final double? orgnlat;
  final double? orgnlong;
  final double? destlat;
  final double? destlong;
  final double? totalDistance;
  final String? id;
  final double? totalPrice;
  late final int? divisionValue;
  RequestRide({
    Key? key,
    this.driverName,
    this.driverCarType,
    this.driverCarNo,
    this.driverPickupLoc,
    this.driverDropoffLoc,
    this.driverAC,
    this.driverseats,
    this.orgnlat,
    this.orgnlong,
    this.destlat,
    this.destlong,
    this.id,
    this.totalDistance,
    this.totalPrice,
    this.divisionValue,
  }) : super(key: key);

  @override
  State<RequestRide> createState() => _RequestRideState();
}

class _RequestRideState extends State<RequestRide> {
  Set<Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  Completer<GoogleMapController> _controller = Completer();
  PolylinePoints polylinePoints = PolylinePoints();
  var kGoogleApiKey = "AIzaSyDHZomR5ozaTualggVoaq5Z2fZIFC_03eQ";
  double _originLatitude = 0.0, _originLongitude = 0.0;
  double _destLatitude = 0.0, _destLongitude = 0.0;
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  List<LatLng> polylineCoordinates = [];
  double totalDistance = 0;
  bool flag = false;
  var time;
  var now;
  var counter = 1;

  @override
  void initState() {
    print("Device token ");
    _originLatitude = widget.orgnlat!;
    _originLongitude = widget.orgnlong!;
    _destLatitude = widget.destlat!;
    _destLongitude = widget.destlong!;
    totalDistance = widget.totalDistance!;
    // widget.divisionValue = counter;
    print(widget.destlat);
    // displayPrediction(widget.driverPickupLoc, widget.driverDropoffLoc, context);
    print("fffffffffffff");
    print(widget.driverPickupLoc);
    setSourceAndDestinationIcons();
    //print(widget.token);
    super.initState();
  }

  late FlutterLocalNotificationsPlugin localNotif;

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), "assets/driving_pin.png");
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "assets/destination_map_marker.png");
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Hello", "The Travel App",
        importance: Importance.high);
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotif.show(0, "Ride",
        'Your fare has been updated ${widget.totalPrice}', generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[800],
        title: new Text(
          "Request Ride",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        toolbarHeight: 70.0,
        elevation: 5.0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              FittedBox(
                fit: BoxFit.fitHeight,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 30.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          15.0, // Move to right 10  horizontally
                          15.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 40,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.driverName!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.driverCarType!,
                                ),
                                Text(
                                  widget.driverCarNo!,
                                )
                              ],
                            ),
                            Spacer(),
                            Text(
                              "Rs. ${widget.totalPrice!.truncate()}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.directions_car_rounded,
                                  color: Colors.black,
                                  size: 25.0,
                                ),
                                SizedBox(width: 5.0),
                                Container(
                                  width: sizeWidth(context) * 0.7,
                                  // width: 70,
                                  child: Text(
                                    widget.driverPickupLoc!,
                                    //cityData['pickUpLocation'],
                                    //  cityData.data!.docs[index]
                                    //  ['pickUpLocation'],
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.arrow_downward_rounded,
                                color: Colors.black,
                                size: 25.0,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.black,
                                  size: 25.0,
                                ),
                                SizedBox(width: 5.0),
                                Container(
                                  width: sizeWidth(context) * 0.7,
                                  child: Text(
                                    widget.driverDropoffLoc!,
                                    //cityData['dropOffLoacation'],
                                    // snapshot.data!.docs[index]
                                    //     ['dropOffLoacation'],
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          totalDistance.toStringAsFixed(2) + " KM",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "${widget.driverseats} Available seats",
                            ),
                            Text("AC"),
                            ElevatedButton(
                              onPressed: () async {
                                print('tappppped');
                                var seats;
                                var calPrice;
                                var divider;
                                // flag = true;
                                setState(() {
                                  now = DateTime.now();
                                  time = DateFormat('dd-MM-yyyy').format(now);
                                  flag = true;
                                  seats = widget.driverseats! - 1;
                                  divider = widget.divisionValue! + 1;
                                  calPrice = widget.totalPrice!/divider;
                                  print("uuuuuuuuuuuuuu");
                                  print(widget.totalPrice);
                                  print(divider);
                                  
                                print("uuuuuuuuuuuuuu");
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                //Return String
                                var userEmail = prefs.getString('useremail');
                                print("iiiiiiiiiiiiiii");
                                print("user id" + widget.id!);
                                FirebaseFirestore.instance
                                    .collection('SharingDriver')
                                    .doc(widget.id)
                                    .update({"seats": seats});

                                FirebaseFirestore.instance
                                    .collection('SharingDriver')
                                    .doc(widget.id)
                                    .update({"calculatedPrice": calPrice});

                                FirebaseFirestore.instance
                                    .collection('SharingDriver')
                                    .doc(widget.id)
                                    .update({"divisionValue": divider});
                                // FirebaseFirestore.instance
                                //     .collection('Users')
                                //     .doc(widget.id)
                                //     .update({"IsNewUser": "1"}).then(
                                //         (result) {
                                //   print("new USer true");
                                // }).catchError((onError) {
                                //   print("onError");
                                // });
                                
                                
                                print("iiiiiiiiiiiiiii");
                                // add data in db of dailyrides
                                await Database.addSharing(
                                  from: widget.driverPickupLoc,
                                  destination: widget.driverDropoffLoc,
                                  totalDistance: widget.totalDistance,
                                  totalPrice: totalDistance * 30,
                                  dateTime: now,
                                  // driverid: widget.phone,
                                  email: userEmail,
                                  nopassengers: 1,
                                  // userid: userEmail,
                                  // flag: flag
                                );
                                _showNotification();
                                CustomSnacksBar.showSnackBar(
                                    context, "Request Send Successfully");
                                Future.delayed(Duration(seconds: 5),
                                () {
                                  // 5s over, navigate to a new page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RideConfirmed()),
                                  );
                                });
                              },
                              child: Text("Confirm"),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey[800]),
                              ),
                            ),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     setState(() {
                            //       widget.driverseats = seats - 1;
                            //     });
                            //     if (snapshot.data!.docs[index]
                            //             ['totalseats'] ==
                            //         0) {
                            //       _showMessageInScaffold(
                            //           "No seats available");
                            //     } else {
                            //       Navigator.of(context)
                            //           .pushReplacement(
                            //         MaterialPageRoute(
                            //           builder: (BuildContext
                            //                   context) =>
                            //               RequestRide(),
                            //         ),
                            //       );
                            //     }
                            //   },
                            //   child: Text("Request"),
                            //   style: ButtonStyle(
                            //     backgroundColor:
                            //         MaterialStateProperty.all(
                            //             Colors.grey[800]),
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    //  height: double.infinity,
                    // width: double.infinity,
                    child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(24.903623, 67.198367), zoom: 10),
                        myLocationEnabled: true,
                        tiltGesturesEnabled: true,
                        compassEnabled: true,
                        scrollGesturesEnabled: true,
                        // zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        onMapCreated: onMapCreated, //_onMapCreated,
                        markers: _markers, //Set<Marker>.of(markers.values),
                        polylines: Set<Polyline>.of(polylines.values),
                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(
                              () => PanGestureRecognizer()))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    setMapPins();
    _getPolyline();
    if (_originLatitude != 0.0 || _destLongitude != 0.0) {
      setPolylines();
    }
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId("sourcePin"),
          position:
              LatLng(_originLatitude, _originLongitude), //SOURCE_LOCATION,
          icon: sourceIcon));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId("destPin"),
          position: LatLng(_destLatitude, _destLongitude),
          icon: destinationIcon));
    });
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      //travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGoogleApiKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      // travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  Future<void> displayPrediction(
      dynamic pickup, dynamic dropoff, BuildContext context) async {
    // get detail (lat/lng)

    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse origindetail =
        await _places.getDetailsByPlaceId(pickup);
    final originlat = origindetail.result.geometry!.location.lat;
    final originlng = origindetail.result.geometry!.location.lng;

    PlacesDetailsResponse destdetail =
        await _places.getDetailsByPlaceId(dropoff);
    print("oooooooooooooooooo");
    print(dropoff);
    final destlat = destdetail.result.geometry!.location.lat;
    final destlng = destdetail.result.geometry!.location.lng;
    setState(() {
      // if (widget.driverPickupLoc != null) {
      //   polylineCoordinates.clear();
      // }
      // widget.driverPickupLoc = pickup.description!;
      _originLatitude = originlat;
      _originLongitude = originlng;

      _destLatitude = destlat;
      _destLongitude = destlng;
      // totalDistance = calculateDistance(
      //     _originLatitude, _originLongitude, _destLatitude, _destLongitude);
    });
    if (widget.driverDropoffLoc != null) {
      polylineCoordinates.clear();
    }
    // widget.driverDropoffLoc = dropoff.description!;

    // totalDistance = calculateDistance(
    //     _originLatitude, _originLongitude, _destLatitude, _destLongitude);
    // print('${totalDistance.truncate()} KM');
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("${p.description} - $lat/$lng")),
    //   );
    // }
    setMapPins();
    _getPolyline();
    setPolylines();
  }

  double calculateDistance(
      _originLatitude, _originLongitude, _destLatitude, _destLongitude) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((_destLatitude - _originLatitude) * p) / 2 +
        c(_originLatitude * p) *
            c(_destLatitude * p) *
            (1 - c((_destLongitude - _originLongitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }
}
