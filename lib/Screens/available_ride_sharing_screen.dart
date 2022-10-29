import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:sizer/sizer.dart';
import 'package:travelapp/Screens/pickup_list.dart';
import 'package:travelapp/Screens/request_ride_screen.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/widgets/custome_snackbar.dart';

class AvailableRidePage extends StatefulWidget {
  const AvailableRidePage({Key? key}) : super(key: key);

  @override
  _AvailableRidePageState createState() => _AvailableRidePageState();
}

class _AvailableRidePageState extends State<AvailableRidePage> {
  TextEditingController _controller = new TextEditingController();
  late List<dynamic> _locationList;
  List searchresult = [];
  var kGoogleApiKey = "AIzaSyDHZomR5ozaTualggVoaq5Z2fZIFC_03eQ";
  double _originLatitude = 0.0, _originLongitude = 0.0;
  double _destLatitude = 0.0, _destLongitude = 0.0;

  @override
  void initState() {
    super.initState();

    values();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
    ));
  }

  void values() {
    _locationList = [];
    _locationList.add(" Malir Cantt > M.T Khan Road");
    _locationList.add("Buffer Zone > Clifton");
    _locationList.add("Malir Cantt >Clifton");
    _locationList.add("4k Bus Stop > Clifton");
    // _locationList.add("Buffer Zone > M.T Khan Road");
    // _locationList.add("Malir Cantt > Clifton");
    // _locationList.add("FB Area > M.T Khan Road");
    // _locationList.add("North Karachi >Clifton");
    // _locationList.add("North Karachi > M.T Khan Road");
    // _locationList.add("North Nazimabad > Orangi Town");
    // _locationList.add("Paf Kiet Main Campus > City Campus");
  }

  @override
  Widget build(BuildContext context) {
    var name;
    var carType;
    var carNo;
    var pickupLoc;
    var dropOffLoc;
    var ac;
    var seats;
    var originlat;
    var originlong;
    var destlat;
    var destlong;
    var totalDistance;
    var id;
    var totalPrice;
    var divisionValue;
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[800],
        title: new Text(
          "Available Rides",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        toolbarHeight: 70.0,
        elevation: 5.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('SharingDriver')
              .snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      name = snapshot.data!.docs[index]['name'];
                      carType = snapshot.data!.docs[index]['services'];
                      carNo = snapshot.data!.docs[index]['carno'];
                      pickupLoc = snapshot.data!.docs[index]['pickupaddress'];
                      dropOffLoc = snapshot.data!.docs[index]['dropoffaddress'];
                      originlat = snapshot.data!.docs[index]['orgnlat'];
                      originlong = snapshot.data!.docs[index]['orgnlong'];
                      destlat = snapshot.data!.docs[index]['destlat'];
                      destlong = snapshot.data!.docs[index]['destlong'];
                      ac = "AC";
                      seats = snapshot.data!.docs[index]['seats'];
                      id = snapshot.data!.docs[index].id;
                      totalPrice =
                          snapshot.data!.docs[index]['calculatedPrice'];
                      divisionValue = snapshot.data!.docs[index]['divisionValue'];
                      return new Container(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20),
                            // Container(
                            //   width: sizeWidth(context),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: TextField(
                            //       controller: _controller,
                            //       style: new TextStyle(color: Colors.black),
                            //       decoration: new InputDecoration(
                            //         contentPadding: EdgeInsets.fromLTRB(
                            //             14, 14.0, 0, 14.0),
                            //         suffixIcon: new Icon(Icons.search,
                            //             color: Colors.grey),
                            //         // prefixIcon: new Icon(Icons.search, color: Colors.grey),
                            //         hintText: "Select Location",
                            //         hintStyle:
                            //             new TextStyle(color: Colors.grey),
                            //         enabledBorder: OutlineInputBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(10.0),
                            //             borderSide:
                            //                 BorderSide(color: greyColor)),
                            //         focusedBorder: OutlineInputBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(10.0),
                            //             borderSide:
                            //                 BorderSide(color: greyColor)),
                            //         focusedErrorBorder: OutlineInputBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(10.0),
                            //             borderSide:
                            //                 BorderSide(color: errorColor)),
                            //         errorBorder: OutlineInputBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(10.0),
                            //             borderSide:
                            //                 BorderSide(color: errorColor)),
                            //         disabledBorder: OutlineInputBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(10.0),
                            //             borderSide:
                            //                 BorderSide(color: primaryColor)),
                            //       ),
                            //       onChanged: onSearchTextChanged,
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 10),
                            // Divider(color: greyColor),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Row(
                            //     children: [
                            //       Icon(Icons.car_rental, color: Colors.grey[800], size: 30),
                            //       SizedBox(width: 5.0),
                            //       Text(
                            //         "AVAILABLE RIDES",
                            //         style: new TextStyle(
                            //             fontWeight: FontWeight.bold, fontSize: 10.sp,fontFamily: 'Montserrat',),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // new Flexible(
                            //     child: searchresult.length != 0 || _controller.text.isNotEmpty
                            //         ? new ListView.separated(
                            //             separatorBuilder: (context, index) =>
                            //                 Divider(color: greyColor),
                            //             shrinkWrap: true,
                            //             itemCount: searchresult.length,
                            //             itemBuilder: (BuildContext context, int index) {
                            //               String listData = searchresult[index];
                            //               return InkWell(
                            //                   onTap: () => Navigator.push(
                            //                       context,
                            //                       MaterialPageRoute(
                            //                           builder: (context) => PickupListPg(
                            //                               pickuplist: pickup1,
                            //                               dropofflist: dropoff1))),
                            //                   child: Padding(
                            //                     padding: const EdgeInsets.all(10.0),
                            //                     child: Text(
                            //                       listData.toString(),
                            //                       style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Montserrat',),
                            //                     ),
                            //                   ));
                            //             },
                            //           )
                            //         : new ListView.separated(
                            //             separatorBuilder: (context, index) =>
                            //                 Divider(color: greyColor),
                            //             shrinkWrap: true,
                            //             itemCount: _locationList.length,
                            //             itemBuilder: (BuildContext context, int index) {
                            //               String listData = _locationList[index];
                            //               return InkWell(
                            //                 onTap: () => Navigator.push(
                            //                   context,
                            //                   MaterialPageRoute(
                            //                     builder: (context) => PickupListPg(
                            //                       pickuplist: pickup[index],
                            //                       dropofflist: dropoff[index],
                            //                     ),
                            //                   ),
                            //                 ),
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.all(10.0),
                            //                   child: new Text(listData.toString(),
                            //                       style:
                            //                           TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat',)),
                            //                 ),
                            //               );
                            //             },
                            //           ))
                            Center(
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Container(
                                  //height: 200,
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  //color: Colors.blue,
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
                                          Radius.circular(20.0))),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              //mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['name'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['services'],
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['carno'],
                                                )
                                              ],
                                            ),
                                            Spacer(),
                                            Text(
                                              "Rs. ${totalPrice.truncate()}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.directions_car_rounded,
                                                  color: Colors.black,
                                                  size: 25.0,
                                                ),
                                                SizedBox(width: 5.0),
                                                Container(
                                                  width:
                                                      sizeWidth(context) * 0.7,
                                                  // width: 70,
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        ['pickupaddress'],
                                                    //cityData['pickUpLocation'],
                                                    //  cityData.data!.docs[index]
                                                    //  ['pickUpLocation'],
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w100,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.location_pin,
                                                  color: Colors.black,
                                                  size: 25.0,
                                                ),
                                                SizedBox(width: 5.0),
                                                Container(
                                                  width:
                                                      sizeWidth(context) * 0.7,
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        ['dropoffaddress'],
                                                    //cityData['dropOffLoacation'],
                                                    // snapshot.data!.docs[index]
                                                    //     ['dropOffLoacation'],
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w100,
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
                                          totalDistance = calculateDistance(
                                                originlat,
                                                originlong,
                                                destlat,
                                                destlong,
                                              ).toStringAsFixed(2) +
                                              " KM",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "${seats} Available seats",
                                            ),
                                            Text("AC"),
                                            ElevatedButton(
                                              onPressed: () {
                                                // setState(() {
                                                //   seats = seats - 1;
                                                // });
                                                if (snapshot.data!.docs[index]
                                                        ['seats'] ==
                                                    0) {
                                                  CustomSnacksBar.showSnackBar(
                                                      context,
                                                      "No seats available");
                                                } else {
                                                  print("tapped");
                                                  // displayPrediction(pickup, dropoff, context);

                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            RequestRide(
                                                              driverName: name,
                                                              driverCarType:
                                                                  carType,
                                                              driverCarNo:
                                                                  carNo,
                                                              driverPickupLoc:
                                                                  pickupLoc,
                                                              driverDropoffLoc:
                                                                  dropOffLoc,
                                                              driverAC: ac,
                                                              driverseats:
                                                                  seats,
                                                              orgnlat:
                                                                  originlat,
                                                              orgnlong:
                                                                  originlong,
                                                              destlat: destlat,
                                                              destlong:
                                                                  destlong,
                                                              totalDistance:
                                                                  totalDistance =
                                                                      calculateDistance(
                                                                originlat,
                                                                originlong,
                                                                destlat,
                                                                destlong,
                                                              ),
                                                              id: id,
                                                              totalPrice:
                                                                  totalPrice,
                                                              divisionValue: divisionValue,
                                                            )),
                                                  );
                                                }
                                              },
                                              child: Text("Request"),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.grey[800]),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                : CircularProgressIndicator();
          }),
    );
  }

  Future<void> displayPrediction(
      dynamic pickup, dynamic dropoff, BuildContext context) async {
    print("entered in method");
    print(pickup.placeId);
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse origindetail =
        await _places.getDetailsByPlaceId(pickup.placeId);
    final originlat = origindetail.result.geometry!.location.lat;
    final originlng = origindetail.result.geometry!.location.lng;

    PlacesDetailsResponse destdetail =
        await _places.getDetailsByPlaceId(dropoff.placeId);
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
    // if (widget.driverDropoffLoc != null) {
    //   polylineCoordinates.clear();
    // }

    // get detail (lat/lng)

    // GoogleMapsPlaces _places = GoogleMapsPlaces(
    //   apiKey: kGoogleApiKey,
    //   apiHeaders: await const GoogleApiHeaders().getHeaders(),
    // );
    // PlacesDetailsResponse detail =
    //     await _places.getDetailsByPlaceId(pickup.placeId);
    // final lat = detail.result.geometry!.location.lat;
    // final lng = detail.result.geometry!.location.lng;
    //   setState(() {
    //     // if (widget.driverPickupLoc != null) {
    //     //   polylineCoordinates.clear();
    //     // }
    //     // widget.driverPickupLoc = pickup.description!;
    //     _originLatitude = lat;
    //     _originLongitude = lng;
    //     // totalDistance = calculateDistance(
    //     //     _originLatitude, _originLongitude, _destLatitude, _destLongitude);
    //   });
    //   if (widget.driverDropoffLoc != null) {
    //     polylineCoordinates.clear();
    //   }
    //   // widget.driverDropoffLoc = dropoff.description!;
    //   _destLatitude = lat;
    //   _destLongitude = lng;
    // totalDistance = calculateDistance(
    //     _originLatitude, _originLongitude, _destLatitude, _destLongitude);
    // print('${totalDistance.truncate()} KM');
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("${p.description} - $lat/$lng")),
    //   );
    // }
    // setMapPins();
    // _getPolyline();
    // setPolylines();
  }

  onSearchTextChanged(String text) async {
    searchresult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (int i = 0; i < _locationList.length; i++) {
      String data = _locationList[i];
      if (data.toLowerCase().contains(text.toLowerCase())) {
        searchresult.add(data);
      }
      setState(() {});
    }
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
