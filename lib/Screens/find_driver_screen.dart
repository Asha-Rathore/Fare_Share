import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:travelapp/Screens/poly_line_screen.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/services/database_helper.dart';
import 'package:url_launcher/url_launcher.dart';

//Daily Rides
class CustomemapPage extends StatefulWidget {
  @override
  CustomemapPageState createState() => CustomemapPageState();
}

class CustomemapPageState extends State<CustomemapPage> {
  TextEditingController _inpurangeController = TextEditingController();
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var filterdistance;
  double clatitude = 0.0;
  double clongitude = 0.0;
  @override
  void initState() {
    //print(querysnapshot);
    getCurrentLocation();
    filterdistance = 100;
    super.initState();
    setSourceAndDestinationIcons();
  }

//LocationPermission permission;
  void getCurrentLocation() async {
    print("location permission 1");
    var permission = await Geolocator.checkPermission();
    print("permission check 1");
    print(permission);
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print(serviceEnabled);
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await loc.Location().requestService();
      return Future.error('Location services are disabled.');
    }

    print("permission check 1");
    print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("permission check");
      print(permission);
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    var status = await Permission.locationWhenInUse.serviceStatus.isEnabled;
    //print("location permission");
    // print(status);
    if (status) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        clatitude = position.latitude;
        clongitude = position.longitude;
      });
    }
  }

  //snackbar message
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
      content: Text(message),
    ));
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String phoneNumber = '';
  Completer<GoogleMapController> _controller = Completer();
  //initalize All Marker list
  List<Marker> allMarkers = [];
  late BitmapDescriptor sourceIcon;

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), "assets/driving_pin.png");
  }

  Widget loadMarkerwithRange(dist) {
    allMarkers.clear();
    return StreamBuilder(
        stream: Database.readDriverData(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, i) {
                  double distanceInMeters = Geolocator.distanceBetween(
                      // double.parse(clatitude),
                      // double.parse(clongitude),
                      clatitude,
                      clongitude,
                      snapshot.data!.docs[i]['latitude'],
                      snapshot.data!.docs[i]['longitude']);
                  if (snapshot.data!.docs[i]['servicetype'] == "Daily Rides") {
                    if (distanceInMeters / 1000 < double.parse(dist)) {
                      print("-----------if distanceInMeters-------");
                      // print(distanceInMeters);
                      // print("-------distanceInMeters/1000 ------------");
                      // print(distanceInMeters / 1000);
                      //print(double.parse(dist));
                      //filtermarker(distanceInMeters/1000);
                      //print(distanceInMeters);
                      //allMarkers.clear();

                      allMarkers.add(Marker(
                          markerId: MarkerId(snapshot.data!.docs[i]['name']),
                          draggable: false,
                          infoWindow: InfoWindow(
                              title: snapshot.data!.docs[i]['address']),
                          position: LatLng(snapshot.data!.docs[i]['latitude'],
                              snapshot.data!.docs[i]['longitude']),
                          onTap: () {
                            _settingModalBottomSheet(
                              context,
                              snapshot.data!.docs[i]['phoneno'],
                              //snapshot.data!.docs[i]['address'],
                              snapshot.data!.docs[i]['name'],
                              clatitude,
                              clongitude,
                              snapshot.data!.docs[i]['Email'],
                              snapshot.data!.docs[i]['services'],
                              //snapshot.data!.docs[i]['token']
                            );
                          },
                          icon: sourceIcon));
                    }
                  }
                  return snapshot.data!.docs.length - 1 == i
                      ? Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                    // target: LatLng(24.903623, 67.198367), zoom: 12),
                                    //target: LatLng(24.8679942, 67.3637389), zoom: 12),
                                    target: LatLng(clatitude, clongitude),
                                    zoom: 12),
                                // 24.8679942
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                                zoomControlsEnabled: true,
                                zoomGesturesEnabled: true,
                                scrollGesturesEnabled: true,
                                myLocationEnabled: true,
                                compassEnabled: true,
                                rotateGesturesEnabled: true,
                                mapToolbarEnabled: true,
                                tiltGesturesEnabled: true,
                                gestureRecognizers:
                                    <Factory<OneSequenceGestureRecognizer>>[
                                  new Factory<OneSequenceGestureRecognizer>(
                                    () => new EagerGestureRecognizer(),
                                  ),
                                ].toSet(),
                                // zoomControlsEnabled: true,
                                markers: Set.from(allMarkers),
                                // markers: {
                                //   newyork1Marker,newyork2Marker,newyork3Marker,gramercyMarker,bernardinMarker,blueMarker
                                // },
                              ),
                            )
                          ],
                        )
                      : SizedBox();
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget loadMarker() {
    return StreamBuilder<QuerySnapshot>(
        stream: Database.readDriverData(),
        builder: (context, snapshot) {
          var length = snapshot.data!.docs.length;
          if (!snapshot.hasData && snapshot.data == null) {
            return Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            print(length);
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              if(snapshot.data!.docs[i]['servicetype'] == 'Daily Rides'){
              allMarkers.add(Marker(
                  markerId: MarkerId(snapshot.data!.docs[i]['name']),
                  draggable: false,
                  infoWindow:
                      InfoWindow(title: snapshot.data!.docs[i]['address']),
                  position: LatLng(snapshot.data!.docs[i]['latitude'],
                      snapshot.data!.docs[i]['longitude']),
                  onTap: () {
                    _settingModalBottomSheet(
                      context,
                      snapshot.data!.docs[i]['phoneno'],
                      //snapshot.data!.docs[i]['address'],
                      snapshot.data!.docs[i]['name'],
                      clatitude,
                      clongitude,
                      snapshot.data!.docs[i]['Email'],
                      snapshot.data!.docs[i]['services'],
                      // snapshot.data!.docs[i]['token']
                    );
                    // print("${snapshot.data.docs[i]['address']}");
                    // print("${snapshot.data.docs[i]['phoneno']}");
                  },
                  icon: sourceIcon));
            }
            }
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: LatLng(24.903623, 67.198367), zoom: 10),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: Set.from(allMarkers),
                // markers: {
                //   newyork1Marker,newyork2Marker,newyork3Marker,gramercyMarker,bernardinMarker,blueMarker
                // },
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }

  double zoomVal = 5.0;
  @override
  Widget build(BuildContext context) {
    //retivedata();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Find Driver",
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
          ),
          backgroundColor: Colors.grey[800],
          toolbarHeight: 70.0,
        ),
        body: Stack(
          children: [
            loadMarkerwithRange(filterdistance.toString()),
          ],
        ),
      ),
    );
  }

  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchMinus, color: Color(0xff6200ee)),
          onPressed: () {
            zoomVal--;
            _minus(zoomVal);
          }),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchPlus, color: Color(0xff6200ee)),
          //color:Color(0xff6200ee)),
          onPressed: () {
            zoomVal++;
            _plus(zoomVal);
          }),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    //24.903623, 67.198367
    //40.712776, -74.005974
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(24.903623, 67.198367), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(24.903623, 67.198367), zoom: zoomVal)));
  }

  Widget _buildContainer(BuildContext context) {
    print("msg");
    return StreamBuilder<QuerySnapshot>(
        //stream: Database.readItems(),
        stream: _firestore.collection('Drivers').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 150.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  //itemCount: snapshot.data.docs.length,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    dynamic datalist = snapshot.data!.docs;
                    // markerinatl(datalist);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _boxes(
                        //MechanicDataList[index]['image'],
                        //ds['latitude'],
                        ds['latitude'],
                        ds['longitude'],
                        ds['address'],
                      ),
                    );
                  },
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }

  Widget _boxes(double lat, double long, String restaurantName) {
    print(lat);
    print(long);
    return GestureDetector(
      onTap: () {
        print("on tab");
        _gotoLocation(lat, long);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(restaurantName),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(String restaurantName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            restaurantName,
            style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 5.0),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child: Text(
              "4.1",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
              ),
            )),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 12.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 12.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 12.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 12.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStarHalf,
                color: Colors.amber,
                size: 12.0,
              ),
            ),
            Container(
                child: Text(
              "(946)",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16.0,
              ),
            )),
          ],
        )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16.0,
          ),
        )),
        SizedBox(height: 5.0),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        //lat 30.3753 , longi 69.3451
        // initialCameraPosition:  CameraPosition(target: LatLng(40.712776, -74.005974), zoom: 12),

        initialCameraPosition:
            //clatitude
            CameraPosition(target: LatLng(clatitude, clongitude), zoom: 5),

        //CameraPosition(target: LatLng(24.903623, 67.198367), zoom: 5),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.from(allMarkers),
        // markers: {
        //   newyork1Marker,newyork2Marker,newyork3Marker,gramercyMarker,bernardinMarker,blueMarker
        // },
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }

//phone call methods
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //show bottom sheet
  void _settingModalBottomSheet(
    context,
    dynamic phoneno,
    //dynamic addres,
    dynamic name,
    dynamic currntlat,
    dynamic currentlongi,
    dynamic memail,
    dynamic services,
    //dynamic token,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            // height: sizeheight(context) * 0.6,

            child: Column(
              children: [
                //title
                Container(
                  // height: 80,
                  width: double.infinity,
                  padding: EdgeInsets.all(10.0),
                  color: Colors.grey[800],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //SizedBox(height: 10.0,),
                      Text(
                        "Fare Share",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "Driver ",
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.grey[800],
                    size: 30,
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                //address
                // ListTile(
                //   leading: SvgPicture.asset(
                //     'assets/images/Lcotion.svg',
                //     color: Colors.grey[800],
                //     height: 30,
                //     width: 30,
                //   ),
                //   title: Text(
                //     addres,
                //     style: TextStyle(
                //       fontFamily: 'Montserrat',
                //     ),
                //   ),
                // ),
                //services
                ListTile(
                  leading: Icon(
                    Icons.car_rental,
                    color: Colors.grey[800],
                    size: 30,
                  ),
                  title: Text(
                    services,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
//rating

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Rating",
                        style: TextStyle(
                            fontFamily: 'Montserrat', fontSize: 14.sp),
                      ),
                      SizedBox(width: 10.0),
                      RatingBar.builder(
                        initialRating: 3.5,
                        minRating: 3.5,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        ignoreGestures: true,
                        itemCount: 5,
                        //tapOnlyMode: true,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              print("taped");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PolyLinePointPage(
                                    dname: name,
                                    dphone: phoneno,
                                    dservices: services,
                                    // token: token,
                                  ),
                                ),
                              );

                              //send cu
                              // await Database.addusercrrentloc(
                              //     lati: currntlat,
                              //     longi: currentlongi,
                              //     phono: phoneno,
                              //     memail: memail);
                              // _showDialog();
                              //_showMessageInScaffold("Lacation Send Successfully");
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  shape: BoxShape.circle),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 30,
                                  )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PolyLinePointPage(
                                            dname: name,
                                            dphone: phoneno,
                                            dservices: services,
                                            // token: token,
                                          )));
                            },
                            child: Container(
                                child: Text(
                              " Next",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

//_input range dialog
  // _showinputDialog() async {
  //   await showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           //contentPadding: const EdgeInsets.all(16.0),
  //           content: Container(
  //             width: 200,
  //             height: 150,
  //             child: new Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 Text("Enter Range"),
  //                 new TextField(
  //                   autofocus: true,
  //                   controller: _inpurangeController,
  //                   decoration: new InputDecoration(
  //                     labelText: 'Enter Range in KM*',
  //                     hintText: '0',
  //                     // errorText: _validate ? 'Value Can\'t Be Empty' : null,
  //                   ),
  //                   // onChanged: (value){
  //                   //   setState(() {
  //                   //     filterdistance=value;
  //                   //   });
  //                   //},
  //                 ),
  //                 // password textbox
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Container(
  //                   child: Row(
  //                     //crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       FlatButton(
  //                           child: const Text(
  //                             'CANCEL',
  //                             style: TextStyle(color: Colors.blue),
  //                           ),
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                           }),
  //                       FlatButton(
  //                           child: const Text(
  //                             'ok',
  //                             style: TextStyle(color: Colors.blue),
  //                           ),
  //                           onPressed: () {
  //                             setState(() {
  //                               filterdistance = _inpurangeController.text;
  //                             });
  //                             Navigator.pop(context);
  //                             _inpurangeController.clear();
  //                           }),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  //input dialog
  _showDialog() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //contentPadding: const EdgeInsets.all(16.0),
            content: Container(
              width: 200,
              height: 80,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Location Send Successfully"),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 30,
                          //width: 50,
                          color: primaryColor,
                          child: FlatButton(
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 30,
                          color: primaryColor,
                          child: FlatButton(
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
