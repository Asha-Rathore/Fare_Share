import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:travelapp/seatconfirmed.dart';
import 'package:travelapp/services/database_helper.dart';

class DrawPolyLine extends StatefulWidget {
  double originLatitude;
  double originLongitude;
  double destLatitude;
  double destLongitude;
  double totlaDistance;
  String pickupLocation;
  String dropOffLocation;
  final String? pickupDateTime;
  final String? vehicleType;
  final String? comment;
  final String? pickuptime;
  final String? driverid;
  bool isEventPage;
  DrawPolyLine({
    Key? key,
    this.isEventPage = false,
    this.originLatitude = 0.0,
    this.originLongitude = 0.0,
    this.destLatitude = 0.0,
    this.destLongitude = 0.0,
    this.totlaDistance = 0.0,
    this.pickupLocation = "",
    this.dropOffLocation = "",
    this.pickupDateTime,
    this.vehicleType = "",
    this.comment,
    this.pickuptime,
    this.driverid,
  }) : super(key: key);

  @override
  _DrawPolyLineState createState() => _DrawPolyLineState();
}

class _DrawPolyLineState extends State<DrawPolyLine> {
  late GoogleMapController mapController;

  String time = "";
  var now;
  late FlutterLocalNotificationsPlugin localNotif;

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Hello", "The Travel App",
        importance: Importance.high);
    var iosDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotif.show(0, "Seat Confirmed",
        'Your seat has been confirmed on $time', generalNotificationDetails);
  }

  // double _originLatitude = 24.825671, _originLongitude = 67.13184;
  // double _destLatitude = 24.8614622, _destLongitude = 67.00993879999;
  late double _originLatitude;
  late double _originLongitude;
  late double _destLatitude;
  late double _destLongitude;

  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  var kGoogleApiKey = "AIzaSyDHZomR5ozaTualggVoaq5Z2fZIFC_03eQ";
  //var kGoogleApiKey = "AIzaSyDHZomR5ozaTualggVoaq5Z2fZIFC_03eQ";
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  @override
  void initState() {
    _originLatitude = widget.originLatitude;
    _originLongitude = widget.originLongitude;
    _destLatitude = widget.destLatitude;
    _destLongitude = widget.destLongitude;
    super.initState();
    setSourceAndDestinationIcons();
    var androidInitilize = new AndroidInitializationSettings('logo');
    var iOSinit = new IOSInitializationSettings();
    var initSettings =
        new InitializationSettings(android: androidInitilize, iOS: iOSinit);
    localNotif = new FlutterLocalNotificationsPlugin();
    localNotif.initialize(initSettings);
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

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), "assets/driving_pin.png");
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "assets/destination_map_marker.png");
  }

  //Mode? _mode = Mode.overlay;
  double totalDistance = 0;
  final formKey = GlobalKey<FormState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  // TextEditingController __originController = TextEditingController();
  // TextEditingController _destinationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: homeScaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: const Text(
              "Reserve Your Seats",
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
            ),
            backgroundColor: Colors.grey[800],
            toolbarHeight: 70.0,
          ),
          body: Form(
            key: formKey,
            child: Column(children: [
              Container(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        //padding: EdgeInsets.only(left: 10.0),
                        height: 155.0,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Distance : ${widget.totlaDistance.truncate()} KM",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                "Total Price : ${widget.totlaDistance.truncate() * 30}",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 20.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        now = DateTime.now();
                                        time = DateFormat('dd-MM-yyyy')
                                            .format(now);
                                      });
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      //Return String
                                      var userEmail =
                                          prefs.getString('useremail');
                                      if (widget.isEventPage) {
                                        await Database.addEventCityReserveSeat(
                                          email: userEmail,
                                          bookingDateTime: now,
                                          totalDistance: widget.totlaDistance,
                                          totalPrice: widget.totlaDistance * 30,
                                          pickUpLocation: widget.pickupLocation,
                                          dropOffLoacation:
                                              widget.dropOffLocation,
                                          pickupDateTime: widget.pickupDateTime,
                                          vehicleType: widget.vehicleType,
                                          comment: widget.comment,
                                          pickuptime: widget.pickuptime,
                                          driverId: widget.driverid,
                                        );
                                      } else {
                                        await Database.addInterCityReserveSeat(
                                          email: userEmail,
                                          bookingDateTime: now,
                                          totalDistance: widget.totlaDistance,
                                          totalPrice: widget.totlaDistance * 30,
                                          pickUpLocation: widget.pickupLocation,
                                          dropOffLoacation:
                                              widget.dropOffLocation,
                                          pickupDateTime: widget.pickupDateTime,
                                          vehicleType: widget.vehicleType,
                                          comment: widget.comment,
                                          pickuptime: widget.pickuptime,
                                          driverId: widget.driverid,
                                        );
                                      }
                                      // add data in db of dailyrides
                                      _showNotification();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SeatConfirmed()),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        'Confirm Seat',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey[800]),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                              widget.originLatitude, widget.destLongitude),
                          zoom: 8),
                      myLocationEnabled: true,
                      tiltGesturesEnabled: true,
                      compassEnabled: true,
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      onMapCreated: onMapCreated, //_onMapCreated,
                      markers: _markers, //Set<Marker>.of(markers.values),
                      polylines: Set<Polyline>.of(polylines.values),
                    ),

                    //Conform button
                  ],
                ),
              ),
            ]),
          )),
    );
  }
//

//
  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    setMapPins();
    _getPolyline();
    if (_originLatitude != 0.0 || _destLongitude != 0.0) {
      setPolylines();
    }
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

  //Calculate Distance in Km
  // double calculateDistance(
  //     _originLatitude, _originLongitude, _destLatitude, _destLongitude) {
  //   var p = 0.017453292519943295;
  //   var c = cos;
  //   var a = 0.5 -
  //       c((_destLatitude - _originLatitude) * p) / 2 +
  //       c(_originLatitude * p) *
  //           c(_destLatitude * p) *
  //           (1 - c((_destLongitude - _originLongitude) * p)) /
  //           2;
  //   return 12742 * asin(sqrt(a));
  // }
}
