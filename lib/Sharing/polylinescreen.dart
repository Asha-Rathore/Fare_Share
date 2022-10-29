// import 'dart:async';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'dart:math' show cos, sqrt, asin;
// import 'package:intl/intl.dart';
// import 'package:travelapp/Screens/find_driver_screen.dart';
// import 'package:travelapp/Screens/pickup_list.dart';
// import 'package:travelapp/Sharing/shpayments.dart';
// import 'package:travelapp/Utils/constants.dart';
// import 'package:travelapp/payments.dart';

// class PolyLinePointPage extends StatefulWidget {
//   const PolyLinePointPage({Key? key}) : super(key: key);

//   @override
//   _PolyLinePointPageState createState() => _PolyLinePointPageState();
// }

// class _PolyLinePointPageState extends State<PolyLinePointPage> {

//   int count = 1;
//   late GoogleMapController mapController;

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
//   late BitmapDescriptor sourceIcon;
//   late BitmapDescriptor destinationIcon;
//   @override
//   void initState() {
//     super.initState();
//     setSourceAndDestinationIcons();
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
//                 Navigator.pop(context);
//               },
//               icon: Icon(Icons.arrow_back_ios),
//             ),
//             title: const Text("Sharing Rides",
//                 style: TextStyle(
//                   fontFamily: 'Montserrat',
//                 )),
//             backgroundColor: Colors.grey[800],
//             toolbarHeight: 70.0,
//           ),
//           body: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     child: Column(
//                       children: [
//                         //_buildDropdownMenu(),
//                         InkWell(
//                           onTap: () async {
//                             _handlePressButton(0);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: TextFormField(
//                               controller: __originController,
//                               enabled: false,
//                               decoration: InputDecoration(
//                                 label: Text(
//                                   "From",
//                                   style: TextStyle(
//                                     fontFamily: 'Montserrat',
//                                     fontSize: 20.0,
//                                   ),
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return "Enter correct name";
//                                 } else {
//                                   return null;
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             _handlePressButton(1);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: TextFormField(
//                               controller: _destinationController,
//                               enabled: false,
//                               decoration: InputDecoration(
//                                 label: Text(
//                                   "Where",
//                                   style: TextStyle(
//                                     fontFamily: 'Montserrat',
//                                     fontSize: 20.0,
//                                   ),
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return "Enter correct name";
//                                 } else {
//                                   return null;
//                                 }
//                               },
//                             ),
//                           ),
//                         ),

//                         Align(
//                           alignment: Alignment.topLeft,
//                           child: Container(
//                             height: 114.0,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Text(
//                                       "Total Distance : ${totalDistance.truncate()} KM",
//                                       style: TextStyle(
//                                         fontFamily: 'Montserrat',
//                                         fontSize: 17.0,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Text(
//                                       "Total Price : ${totalDistance.truncate() * 30*count }",
//                                       style: TextStyle(
//                                         fontFamily: 'Montserrat',
//                                         fontSize: 17.0,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top:0.0),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           "No of Passengers :",
//                                           style: TextStyle(
//                                             fontFamily: 'Montserrat',
//                                             fontSize: 17.0,
//                                           ),
//                                         ),
//                                         MaterialButton(
//                                           onPressed:(){
//                                             if(count>=1&&count<=2 && count !=2){
//                                             setState(() {
//                                               count++;
//                                             });
//                                           }}, 
//                                           child: Text(
//                                             '+',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 16.0,
//                                               fontFamily: 'Montserrat',
//                                               fontWeight: FontWeight.bold
//                                             ),
//                                           ),
//                                           shape: const CircleBorder(),
//                                           color: Colors.grey[800],
//                                         ),
//                                         Text(
//                                           '$count',
//                                           style: TextStyle(
//                                             fontFamily: 'Montserrat',
//                                             fontSize: 16.0,
//                                           ),
//                                         ),
//                                         MaterialButton(
//                                           onPressed: (){
//                                              if((count>=1) && (count<=2)&&count != 1){
//                                             setState(() {
//                                               count--;
//                                             });
//                                           }},
//                                           child: Text(
//                                             '-',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 16.0,
//                                               fontFamily: 'Montserrat',
//                                               fontWeight: FontWeight.bold
//                                             ),
//                                           ),
//                                           shape: const CircleBorder(),
//                                           color: Colors.grey[800],
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Text(
//                   //   'PloyLine',
//                   //   style: TextStyle(
//                   //       color: Colors.black,
//                   //       fontSize: 15.0,
//                   //       fontFamily: 'Montserrat',
//                   //       fontWeight: FontWeight.w300),
//                   // ),
//                   Column(
//                     children: [
//                       Container(
//                         height: MediaQuery.of(context).size.height * 0.47,
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
//                     ],
//                   ),
//                   // SizedBox(
//                   //   height: 3.0,
//                   // ),

//                   //   CustomemapPage(),
//                   //Conform button

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 2.0,),
//                         child: Center(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               if (formKey.currentState!.validate()) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => SharingPayments(
//                                       origin: __originController.text,
//                                       destination: _destinationController.text,
//                                       totalDistance: totalDistance.truncate(),
//                                       totalPrice: totalDistance.truncate() * 30,
//                                       passengers: count
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                   content: Text("Please enter location"),
//                                   duration: Duration(seconds: 2),
//                                 ));
//                               }
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 17.0, bottom: 17.0, left: 45.0, right: 45.0),
//                               child: Text(
//                                 'Next',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 15.0,
//                                     fontFamily: 'Montserrat',
//                                     fontWeight: FontWeight.w300),
//                               ),
//                             ),
//                             style: ButtonStyle(
//                               shape:
//                                   MaterialStateProperty.all<RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(18.0),
//                               )),
//                               backgroundColor:
//                                   MaterialStateProperty.all(Colors.grey[800]),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 2.0,),
//                         child: ElevatedButton(
//                           child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 17.0, bottom: 17.0, left: 45.0, right: 45.0),
//                               child: Text(
//                                 'Rides',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 15.0,
//                                     fontFamily: 'Montserrat',
//                                     fontWeight: FontWeight.w300),
//                               ),
//                             ),
//                             style: ButtonStyle(
//                               shape:
//                                   MaterialStateProperty.all<RoundedRectangleBorder>(
//                                       RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(18.0),
//                               )),
//                               backgroundColor:
//                                   MaterialStateProperty.all(Colors.grey[800]),
//                         ),
//                         onPressed: () {
//                           showModalBottomSheet(
//                             context: context, 
//                             isScrollControlled: true,
//                             builder: (context) => 
//                             SingleChildScrollView(
//                               child: Column(
                                
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 10.0),
//                                     child: IconButton(
//                                       onPressed: () => Navigator.pop(context), 
//                                       icon: Icon(Icons.expand_more_rounded,
//                                       size: 50,
//                                       color: Colors.grey,
//                                       )
//                                     ),
//                                   ),
//                                   Container(
//                                     width: double.infinity,
//                                     height: 70,
//                                     padding: EdgeInsets.all(10.0),
//                                     color: Colors.grey[800],
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "Available Rides",
//                                             style: TextStyle(
//                                               fontSize: 24,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                               fontFamily: 'Montserrat',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                   ),
//                                   SizedBox(height: 10,),
//                                   Column(
//                                     children: [
//                                       InkWell(
//                                         onTap:(){
//                                           print("tapped");
//                                           Navigator.push(
//                                             context, 
//                                             MaterialPageRoute(
//                                               builder: (context) => PickupListPg(
//                                                 addresslist: pickup1,
//                                                 dropofflist: dropoff1
//                                               )
//                                             )
//                                           );
//                                         },
//                                         child: Container(
//                                         height: 130,
//                                         decoration: BoxDecoration(
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.grey,
//                                                 blurRadius: 30.0, // soften the shadow
//                                                 spreadRadius: 1.0, //extend the shadow
//                                                 offset: Offset(
//                                                   15.0, // Move to right 10  horizontally
//                                                   15.0, // Move to bottom 10 Vertically
//                                                 ),
//                                               )
//                                             ],
//                                             color: Colors.white,
//                                             borderRadius:
//                                                 BorderRadius.all(Radius.circular(20.0))),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(20.0),
//                                           child: Center(
//                                             child: Column(
//                                               children: [
                                                
//                                                 Row(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Icon(
//                                                       Icons.directions_car_rounded,
//                                                       color: Colors.black,
//                                                       size: 25.0,
//                                                     ),
//                                                     SizedBox(width: 5.0),
//                                                     Container(
//                                                       width: sizeWidth(context) * 0.7,
//                                                       // width: 70,
//                                                       child: Text(
//                                                          "Clifton - Shahrah e Faisal",
//                                                         //cityData['pickUpLocation'],
//                                                         //  cityData.data!.docs[index]
//                                                         //  ['pickUpLocation'],
//                                                         style: TextStyle(
//                                                             fontFamily: 'Montserrat',
//                                                             fontSize: 15.0,
//                                                             fontWeight: FontWeight.w100,
//                                                             color: Colors.black),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 SizedBox(
//                                                   height: 5.0,
//                                                 ),
//                                                 Align(
//                                                   alignment: Alignment.centerLeft,
//                                                   child: Icon(
//                                                     Icons.arrow_downward_rounded,
//                                                     color: Colors.black,
//                                                     size: 25.0,
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 5.0,
//                                                 ),
//                                                 Row(
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Icon(
//                                                       Icons.location_pin,
//                                                       color: Colors.black,
//                                                       size: 25.0,
//                                                     ),
//                                                     SizedBox(width: 5.0),
//                                                     Container(
//                                                       width: sizeWidth(context) * 0.7,
//                                                       child: Text(
//                                                          "Malir Cantt",
//                                                         //cityData['dropOffLoacation'],
//                                                         // snapshot.data!.docs[index]
//                                                         //     ['dropOffLoacation'],
//                                                         style: TextStyle(
//                                                             fontFamily: 'Montserrat',
//                                                             fontSize: 15.0,
//                                                             fontWeight: FontWeight.w100,
//                                                             color: Colors.black),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                                                       ),
//                                       ),
                                  
//                                   SizedBox(height: 10,),
//                                   InkWell(
//                                     onTap:(){
//                                           print("tapped");
//                                           Navigator.push(
//                                             context, 
//                                             MaterialPageRoute(
//                                               builder: (context) => PickupListPg(
//                                                 addresslist: pickup2,
//                                                 dropofflist: dropoff2
//                                               )
//                                             )
//                                           );
//                                         },
//                                     child: Container(
//                                       height: 130,
//                                       decoration: BoxDecoration(
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.grey,
//                                               blurRadius: 30.0, // soften the shadow
//                                               spreadRadius: 1.0, //extend the shadow
//                                               offset: Offset(
//                                                 15.0, // Move to right 10  horizontally
//                                                 15.0, // Move to bottom 10 Vertically
//                                               ),
//                                             )
//                                           ],
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.all(Radius.circular(20.0))),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(20.0),
//                                         child: Center(
//                                           child: Column(
//                                             children: [
//                                               Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.directions_car_rounded,
//                                                     color: Colors.black,
//                                                     size: 25.0,
//                                                   ),
//                                                   SizedBox(width: 5.0),
//                                                   Container(
//                                                     width: sizeWidth(context) * 0.7,
//                                                     // width: 70,
//                                                     child: Text(
//                                                        "Safoora - Gulistan e Jauhar",
//                                                       //cityData['pickUpLocation'],
//                                                       //  cityData.data!.docs[index]
//                                                       //  ['pickUpLocation'],
//                                                       style: TextStyle(
//                                                           fontFamily: 'Montserrat',
//                                                           fontSize: 15.0,
//                                                           fontWeight: FontWeight.w100,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(
//                                                 height: 5.0,
//                                               ),
//                                               Align(
//                                                 alignment: Alignment.centerLeft,
//                                                 child: Icon(
//                                                   Icons.arrow_downward_rounded,
//                                                   color: Colors.black,
//                                                   size: 25.0,
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 5.0,
//                                               ),
//                                               Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.location_pin,
//                                                     color: Colors.black,
//                                                     size: 25.0,
//                                                   ),
//                                                   SizedBox(width: 5.0),
//                                                   Container(
//                                                     width: sizeWidth(context) * 0.7,
//                                                     child: Text(
//                                                        "Shahrah e Faisal - MT Khan Road",
//                                                       //cityData['dropOffLoacation'],
//                                                       // snapshot.data!.docs[index]
//                                                       //     ['dropOffLoacation'],
//                                                       style: TextStyle(
//                                                           fontFamily: 'Montserrat',
//                                                           fontSize: 15.0,
//                                                           fontWeight: FontWeight.w100,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 10,),
//                                   InkWell(
//                                     onTap:(){
//                                           print("tapped");
//                                           Navigator.push(
//                                             context, 
//                                             MaterialPageRoute(
//                                               builder: (context) => PickupListPg(
//                                                 addresslist: pickup3,
//                                                 dropofflist: dropoff3
//                                               )
//                                             )
//                                           );
//                                         },
//                                     child: Container(
//                                       height: 130,
//                                       decoration: BoxDecoration(
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.grey,
//                                               blurRadius: 30.0, // soften the shadow
//                                               spreadRadius: 1.0, //extend the shadow
//                                               offset: Offset(
//                                                 15.0, // Move to right 10  horizontally
//                                                 15.0, // Move to bottom 10 Vertically
//                                               ),
//                                             )
//                                           ],
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.all(Radius.circular(20.0))),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(20.0),
//                                         child: Center(
//                                           child: Column(
//                                             children: [
                                              
//                                               Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.directions_car_rounded,
//                                                     color: Colors.black,
//                                                     size: 25.0,
//                                                   ),
//                                                   SizedBox(width: 5.0),
//                                                   Container(
//                                                     width: sizeWidth(context) * 0.7,
//                                                     // width: 70,
//                                                     child: Text(
//                                                        "Buffer Zone - North Nazimabad",
//                                                       //cityData['pickUpLocation'],
//                                                       //  cityData.data!.docs[index]
//                                                       //  ['pickUpLocation'],
//                                                       style: TextStyle(
//                                                           fontFamily: 'Montserrat',
//                                                           fontSize: 15.0,
//                                                           fontWeight: FontWeight.w100,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(
//                                                 height: 5.0,
//                                               ),
//                                               Align(
//                                                 alignment: Alignment.centerLeft,
//                                                 child: Icon(
//                                                   Icons.arrow_downward_rounded,
//                                                   color: Colors.black,
//                                                   size: 25.0,
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 5.0,
//                                               ),
//                                               Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.location_pin,
//                                                     color: Colors.black,
//                                                     size: 25.0,
//                                                   ),
//                                                   SizedBox(width: 5.0),
//                                                   Container(
//                                                     width: sizeWidth(context) * 0.7,
//                                                     child: Text(
//                                                        "Shahrah e Faisal - DHA",
//                                                       //cityData['dropOffLoacation'],
//                                                       // snapshot.data!.docs[index]
//                                                       //     ['dropOffLoacation'],
//                                                       style: TextStyle(
//                                                           fontFamily: 'Montserrat',
//                                                           fontSize: 15.0,
//                                                           fontWeight: FontWeight.w100,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 10,),
//                                   InkWell(
//                                     onTap:(){
//                                           print("tapped");
//                                           Navigator.push(
//                                             context, 
//                                             MaterialPageRoute(
//                                               builder: (context) => PickupListPg(
//                                                 addresslist: pickup4,
//                                                 dropofflist: dropoff4
//                                               )
//                                             )
//                                           );
//                                         },
//                                     child: Container(
//                                       height: 150,
//                                       decoration: BoxDecoration(
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.grey,
//                                               blurRadius: 30.0, // soften the shadow
//                                               spreadRadius: 1.0, //extend the shadow
//                                               offset: Offset(
//                                                 15.0, // Move to right 10  horizontally
//                                                 15.0, // Move to bottom 10 Vertically
//                                               ),
//                                             )
//                                           ],
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.all(Radius.circular(20.0))),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(20.0),
//                                         child: Center(
//                                           child: Column(
//                                             children: [
                                              
//                                               Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.directions_car_rounded,
//                                                     color: Colors.black,
//                                                     size: 25.0,
//                                                   ),
//                                                   SizedBox(width: 5.0),
//                                                   Container(
//                                                     width: sizeWidth(context) * 0.7,
//                                                     // width: 70,
//                                                     child: Text(
//                                                        "Clifton - Dow - IBA City Campus Bahadurabad",
//                                                       //cityData['pickUpLocation'],
//                                                       //  cityData.data!.docs[index]
//                                                       //  ['pickUpLocation'],
//                                                       style: TextStyle(
//                                                           fontFamily: 'Montserrat',
//                                                           fontSize: 15.0,
//                                                           fontWeight: FontWeight.w100,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(
//                                                 height: 5.0,
//                                               ),
//                                               Align(
//                                                 alignment: Alignment.centerLeft,
//                                                 child: Icon(
//                                                   Icons.arrow_downward_rounded,
//                                                   color: Colors.black,
//                                                   size: 25.0,
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 5.0,
//                                               ),
//                                               Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.location_pin,
//                                                     color: Colors.black,
//                                                     size: 25.0,
//                                                   ),
//                                                   SizedBox(width: 5.0),
//                                                   Container(
//                                                     width: sizeWidth(context) * 0.7,
//                                                     child: Text(
//                                                        "University Road - Gulistan e Jauhar",
//                                                       //cityData['dropOffLoacation'],
//                                                       // snapshot.data!.docs[index]
//                                                       //     ['dropOffLoacation'],
//                                                       style: TextStyle(
//                                                           fontFamily: 'Montserrat',
//                                                           fontSize: 15.0,
//                                                           fontWeight: FontWeight.w100,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 10,),
//                                   InkWell(
//                                     onTap:(){
//                                           print("tapped");
//                                           Navigator.push(
//                                             context, 
//                                             MaterialPageRoute(
//                                               builder: (context) => PickupListPg(
//                                                 addresslist: pickup5,
//                                                 dropofflist: dropoff5
//                                               )
//                                             )
//                                           );
//                                         },
//                                     child: Container(
//                                       height: 140,
//                                       decoration: BoxDecoration(
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.grey,
//                                               blurRadius: 30.0, // soften the shadow
//                                               spreadRadius: 1.0, //extend the shadow
//                                               offset: Offset(
//                                                 15.0, // Move to right 10  horizontally
//                                                 15.0, // Move to bottom 10 Vertically
//                                               ),
//                                             )
//                                           ],
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.all(Radius.circular(20.0))),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(20.0),
//                                         child: Center(
//                                           child: Column(
//                                             children: [
                                              
//                                               Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.directions_car_rounded,
//                                                     color: Colors.black,
//                                                     size: 25.0,
//                                                   ),
//                                                   SizedBox(width: 5.0),
//                                                   Container(
//                                                     width: sizeWidth(context) * 0.7,
//                                                     // width: 70,
//                                                     child: Text(
//                                                        "Habib University - Gulistan e Jauhar",
//                                                       //cityData['pickUpLocation'],
//                                                       //  cityData.data!.docs[index]
//                                                       //  ['pickUpLocation'],
//                                                       style: TextStyle(
//                                                           fontFamily: 'Montserrat',
//                                                           fontSize: 15.0,
//                                                           fontWeight: FontWeight.w100,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(
//                                                 height: 5.0,
//                                               ),
//                                               Align(
//                                                 alignment: Alignment.centerLeft,
//                                                 child: Icon(
//                                                   Icons.arrow_downward_rounded,
//                                                   color: Colors.black,
//                                                   size: 25.0,
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 height: 5.0,
//                                               ),
//                                               Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.location_pin,
//                                                     color: Colors.black,
//                                                     size: 25.0,
//                                                   ),
//                                                   SizedBox(width: 5.0),
//                                                   Container(
//                                                     width: sizeWidth(context) * 0.7,
//                                                     child: Text(
//                                                        "DHA - Gizri",
//                                                       //cityData['dropOffLoacation'],
//                                                       // snapshot.data!.docs[index]
//                                                       //     ['dropOffLoacation'],
//                                                       style: TextStyle(
//                                                           fontFamily: 'Montserrat',
//                                                           fontSize: 15.0,
//                                                           fontWeight: FontWeight.w100,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ]
//                                 )
//                                 ],
//                               ),
//                             )
//                           );
//                         },
//                         ),
//                       ),
//                     ],
//                   )
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
