// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:sizer/sizer.dart';
// import 'package:travelapp/Screens/driver_profile_screen.dart';
// import 'dart:math' show cos, sqrt, asin;
// import 'package:travelapp/services/database_helper.dart';

// class DriverMainPage extends StatefulWidget {
  
//   const DriverMainPage({Key? key}) : super(key: key);

//   @override
//   _DriverMainPageState createState() => _DriverMainPageState();
// }

// class _DriverMainPageState extends State<DriverMainPage> {
//   late GoogleMapController mapController;

//   bool flag = false;

//   // double _originLatitude = 24.825671, _originLongitude = 67.13184;
//   // double _destLatitude = 24.8614622, _destLongitude = 67.00993879999;
//   double _originLatitude = 0.0, _originLongitude = 0.0;
//   double _destLatitude = 0.0, _destLongitude = 0.0;

//   Set<Marker> _markers = {};
//   Completer<GoogleMapController> _controller = Completer();
//   Map<PolylineId, Polyline> polylines = {};
//   List<LatLng> polylineCoordinates = [];
//   PolylinePoints polylinePoints = PolylinePoints();
//   var kGoogleApiKey = "AIzaSyBW5iOvTYmTq9B77_bB_lHL1xsA1qT5u2Y";
//   //var kGoogleApiKey = "AIzaSyDHZomR5ozaTualggVoaq5Z2fZIFC_03eQ";
//   late BitmapDescriptor sourceIcon;
//   late BitmapDescriptor destinationIcon;

//   //var phoneno;

//   // storeNotificationToken() async {
//   //   print("jhggjjhggg");
//   //   Database.readDriverData();
//   //   String? token = await FirebaseMessaging.instance.getToken();
//   //   // SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   //                         //Return String
//   //   //                         var phoneno = prefs.getString('phoneno');

//   //   FirebaseFirestore.instance
//   //       .collection('Drivers')
//   //       .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
//   //       .set(
//   //     {'token': token},
//   //     //   SetOptions(merge: true)
//   //   );
//   //   print(FirebaseAuth.instance.currentUser!.phoneNumber);
//   //   print(token);
//   // }

//   void _settingModalBottomSheet(
//       context,
//       dynamic phoneno,
//       dynamic addres,
//       dynamic name,
//       dynamic currntlat,
//       dynamic currentlongi,
//       dynamic memail,
//       dynamic services) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return Container(
//             // height: sizeheight(context) * 0.6,

//             child: Column(
//               children: [
//                 //title
//                 Container(
//                   // height: 80,
//                   width: double.infinity,
//                   padding: EdgeInsets.all(10.0),
//                   color: Colors.grey[800],
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       //SizedBox(height: 10.0,),
//                       Text(
//                         "Trip For You",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontFamily: 'Montserrat',
//                         ),
//                       ),
//                       SizedBox(
//                         height: 4.0,
//                       ),
//                     ],
//                   ),
//                 ),
//                 ListTile(
//                   leading: Icon(
//                     Icons.drive_eta_rounded,
//                     color: Colors.grey[800],
//                     size: 30,
//                   ),
//                   title: Text(
//                     "Source",
//                     style: TextStyle(
//                       fontFamily: 'Montserrat',
//                     ),
//                   ),
//                 ),
//                 //address
//                 ListTile(
//                   leading: Icon(
//                     Icons.location_pin,
//                     color: Colors.grey[800],
//                     size: 30,
//                   ),
//                   title: Text(
//                     "Destination",
//                     style: TextStyle(
//                       fontFamily: 'Montserrat',
//                     ),
//                   ),
//                   //Text("Address"),
//                 ),
//                 //services
//                 ListTile(
//                   leading: Icon(
//                     Icons.social_distance,
//                     color: Colors.grey[800],
//                     size: 30,
//                   ),
//                   title: Text(
//                     "Distance",
//                     style: TextStyle(
//                       fontFamily: 'Montserrat',
//                     ),
//                   ),
//                   //Text("Address"),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Column(
//                         children: [
//                           InkWell(
//                             onTap: () async {
//                               // Navigator.push(context, MaterialPageRoute(builder:
//                               // (BuildContext context)=>PolyLinePointPage(
//                               //   dname: name,
//                               //         dphone: phoneno,
//                               //         dservices: services
//                               // )));
//                             },
//                             child: Container(
//                               height: 60,
//                               width: 60,
//                               decoration: BoxDecoration(
//                                   color: Colors.grey[800],
//                                   shape: BoxShape.circle),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                       child: Icon(
//                                     Icons.location_on,
//                                     color: Colors.white,
//                                     size: 30,
//                                   )),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           InkWell(
//                             onTap: () {
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //     builder: (
//                               //       BuildContext context)=>
//                               //       PolyLinePointPage(
//                               //         dname: name,
//                               //         dphone: phoneno,
//                               //         dservices: services
//                               //       )
//                               //     )
//                               //   );
//                             },
//                             child: Container(
//                                 child: Text(
//                               " Next",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: 'Montserrat',
//                               ),
//                             )),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   @override
//   void initState() {
//     super.initState();
//     setSourceAndDestinationIcons();
//     // FirebaseMessaging.onMessage.listen((event) {
//     //   print('**************************************************************FCM');
//     //   //LocalNotificationService.display(event);
//     // });
//     // storeNotificationToken();
//   }

//   void setMapPins() {
//     setState(() {
//       // source pin
//       _markers.add(Marker(
//           markerId: MarkerId("sourcePin"),
//           position:
//               LatLng(_originLatitude, _originLongitude), //SOURCE_LOCATION,
//           icon: sourceIcon));
//       // destination pin
//       _markers.add(Marker(
//           markerId: MarkerId("destPin"),
//           position: LatLng(_destLatitude, _destLongitude),
//           icon: destinationIcon));
//     });
//   }

//   void setSourceAndDestinationIcons() async {
//     sourceIcon = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 2.5), "assets/driving_pin.png");
//     destinationIcon = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(devicePixelRatio: 2.5),
//         "assets/destination_map_marker.png");
//   }

//   //Mode? _mode = Mode.overlay;
//   double totalDistance = 0;
//   final formKey = GlobalKey<FormState>();
//   final homeScaffoldKey = GlobalKey<ScaffoldState>();
//   TextEditingController __originController = TextEditingController();
//   TextEditingController _destinationController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           key: homeScaffoldKey,
//           appBar: AppBar(
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                     MaterialPageRoute(builder: (_) => DriverProfileScreen()));
//               },
//               icon: Icon(Icons.arrow_back_ios),
//             ),
//             title: const Text("The Travel App",
//                 style: TextStyle(
//                   fontFamily: 'Montserrat',
//                 )),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 15.0, right: 10.0),
//                 child: Text("Ride Competed",
//                     style:
//                         TextStyle(fontFamily: 'Montserrat', fontSize: 14.sp)),
//               )
//             ],
//             backgroundColor: Colors.grey[800],
//             //toolbarHeight: 70.0,
//           ),
//           body: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Column(
//                     children: [
//                       Container(
//                         color: Colors.grey[800],
//                         height: MediaQuery.of(context).size.height * 0.8,
//                         //  height: double.infinity,
//                         // width: double.infinity,
//                         child: GoogleMap(
//                           initialCameraPosition: CameraPosition(
//                               target: LatLng(24.903623, 67.198367), zoom: 10),
//                           myLocationEnabled: true,
//                           tiltGesturesEnabled: true,
//                           compassEnabled: true,
//                           scrollGesturesEnabled: true,
//                           // zoomGesturesEnabled: true,
//                           zoomControlsEnabled: true,
//                           onMapCreated: onMapCreated, //_onMapCreated,
//                           markers: _markers, //Set<Marker>.of(markers.values),
//                           polylines: Set<Polyline>.of(polylines.values),
//                         ),
//                       ),
//                       Container(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             "Finding Trip",
//                             style: TextStyle(
//                                 fontFamily: "Montserrat",
//                                 fontSize: 22.0,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   // SizedBox(
//                   //   height: 3.0,
//                   // ),

//                   //   CustomemapPage(),
//                   //Conform button

//                   // Container(
//                   //   color: Colors.white.withOpacity(0.6),
//                   //   child: Padding(
//                   //     padding: const EdgeInsets.all(5.0),
//                   //     child: ElevatedButton(
//                   //       onPressed: () {
//                   //         if (formKey.currentState!.validate()) {
//                   //           Navigator.push(
//                   //             context,
//                   //             MaterialPageRoute(
//                   //               builder: (context) => PaymentsPage(
//                   //                 origin: __originController.text,
//                   //                 destination: _destinationController.text,
//                   //                 totalDistance: totalDistance.truncate(),
//                   //                 totalPrice: totalDistance.truncate() * 30,
//                   //               ),
//                   //             ),
//                   //           );
//                   //         } else {
//                   //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   //             content: Text("Please enter location"),
//                   //             duration: Duration(seconds: 2),
//                   //           ));
//                   //         }
//                   //       },
//                   //       child: Padding(
//                   //         padding: const EdgeInsets.only(
//                   //             top: 17.0, bottom: 17.0, left: 45.0, right: 45.0),
//                   //         child: Text(
//                   //           'YOU\'RE ONLINE',
//                   //           style: TextStyle(
//                   //               color: Colors.white,
//                   //               fontSize: 15.0,
//                   //               fontFamily: 'Montserrat',
//                   //               fontWeight: FontWeight.w300),
//                   //         ),
//                   //       ),
//                   //       style: ButtonStyle(
//                   //         shape:
//                   //             MaterialStateProperty.all<RoundedRectangleBorder>(
//                   //                 RoundedRectangleBorder(
//                   //           borderRadius: BorderRadius.circular(30.0),
//                   //         )),
//                   //         backgroundColor:
//                   //             MaterialStateProperty.all(Colors.grey[800]),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// //

//   void onError(PlacesAutocompleteResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(response.errorMessage!)),
//     );
//   }

//   Future<void> _handlePressButton(int id) async {
//     // show input autocomplete with selected mode
//     // then get the Prediction selected
//     var p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: kGoogleApiKey,
//       onError: onError,
//       mode: Mode.overlay,
//       language: "en",
//       types: [],
//       strictbounds: false,
//       decoration: InputDecoration(
//         hintText: 'Search',
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: const BorderSide(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       components: [Component(Component.country, "pk")],
//     );

//     displayPrediction(p!, context, id);
//   }

//   Future<void> displayPrediction(
//       Prediction p, BuildContext context, int id) async {
//     if (p != null) {
//       // get detail (lat/lng)

//       GoogleMapsPlaces _places = GoogleMapsPlaces(
//         apiKey: kGoogleApiKey,
//         apiHeaders: await const GoogleApiHeaders().getHeaders(),
//       );
//       PlacesDetailsResponse detail =
//           await _places.getDetailsByPlaceId(p.placeId!);
//       final lat = detail.result.geometry!.location.lat;
//       final lng = detail.result.geometry!.location.lng;
//       if (id == 0) {
//         setState(() {
//           if (__originController.text.isNotEmpty) {
//             polylineCoordinates.clear();
//           }
//           __originController.text = p.description!;
//           _originLatitude = lat;
//           _originLongitude = lng;
//           totalDistance = calculateDistance(
//               _originLatitude, _originLongitude, _destLatitude, _destLongitude);
//         });
//       } else if (id == 1) {
//         if (_destinationController.text.isNotEmpty) {
//           polylineCoordinates.clear();
//         }
//         _destinationController.text = p.description!;
//         _destLatitude = lat;
//         _destLongitude = lng;
//         totalDistance = calculateDistance(
//             _originLatitude, _originLongitude, _destLatitude, _destLongitude);
//         print('${totalDistance.truncate()} KM');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("${p.description} - $lat/$lng")),
//         );
//       }
//       setMapPins();
//       _getPolyline();
//       setPolylines();
//     }
//   }

// //
//   void onMapCreated(GoogleMapController controller) {
//     _controller.complete(controller);

//     setMapPins();
//     _getPolyline();
//     if (_originLatitude != 0.0 || _destLongitude != 0.0) {
//       setPolylines();
//     }
//   }

//   _addPolyLine(List<LatLng> polylineCoordinates) {
//     PolylineId id = PolylineId("poly");
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.black,
//       points: polylineCoordinates,
//       width: 5,
//     );
//     polylines[id] = polyline;
//     setState(() {});
//   }

//   void _getPolyline() async {
//     List<LatLng> polylineCoordinates = [];

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       kGoogleApiKey,
//       PointLatLng(_originLatitude, _originLongitude),
//       PointLatLng(_destLatitude, _destLongitude),
//       //travelMode: TravelMode.driving,
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     _addPolyLine(polylineCoordinates);
//   }

//   setPolylines() async {
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       kGoogleApiKey,
//       PointLatLng(_originLatitude, _originLongitude),
//       PointLatLng(_destLatitude, _destLongitude),
//       // travelMode: TravelMode.driving,
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     _addPolyLine(polylineCoordinates);
//   }

//   //Calculate Distance in Km
//   double calculateDistance(
//       _originLatitude, _originLongitude, _destLatitude, _destLongitude) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((_destLatitude - _originLatitude) * p) / 2 +
//         c(_originLatitude * p) *
//             c(_destLatitude * p) *
//             (1 - c((_destLongitude - _originLongitude) * p)) /
//             2;
//     return 12742 * asin(sqrt(a));
//   }
// }
