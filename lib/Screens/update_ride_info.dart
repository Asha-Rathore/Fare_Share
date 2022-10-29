import 'dart:developer';
import 'dart:math';
//import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/Screens/login_driver_screen.dart';
import 'package:travelapp/Screens/request_ride_screen.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/Utils/extensions.dart';
import 'package:travelapp/services/database_helper.dart';
import 'package:travelapp/widgets/custome_snackbar.dart';

class UpdateRideInfo extends StatefulWidget {
  @override
  _UpdateRideInfoState createState() => _UpdateRideInfoState();
}

class _UpdateRideInfoState extends State<UpdateRideInfo> {
  var locationMessage = '';
  String? latitude;
  String? longitude;
  String? eml;
  //loaction
  void getCurrentLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        await loc.Location().requestService();
        return Future.error('Location services are disabled.');
      }
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
    } catch (e) {
      print("catch*************************");
      CustomSnacksBar.showSnackBar(context, e.toString());
    }
  }

  //snackbar message
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
    ));
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool? _success;
  String? _mechemail;
  final TextEditingController _pickupaddressController =
      TextEditingController();
  final TextEditingController _dropoffaddressController =
      TextEditingController();
  final TextEditingController _servicesController = TextEditingController();
  final TextEditingController _carnoController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  //int var = int.parse(_seatsController.text);
  var kGoogleApiKey = "AIzaSyDHZomR5ozaTualggVoaq5Z2fZIFC_03eQ";
  double _originLatitude = 0.0, _originLongitude = 0.0;
  double _destLatitude = 0.0, _destLongitude = 0.0;
  String? _email, _password, _name;
  int divValue = 1;

  var pickup, dropoff;
  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    _pickupaddressController.dispose();
    _dropoffaddressController.dispose();
    _servicesController.dispose();
    _seatsController.dispose();
    _carnoController.dispose();
    super.dispose();
  }

  clearTextInput() {
    _pickupaddressController.clear();
    _dropoffaddressController.clear();
    _servicesController.clear();
    _seatsController.clear();
    _carnoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: StreamBuilder<QuerySnapshot>(
          stream: Database.readSharingDriverData(),
          builder: (context, snapshot) {
            if (snapshot.hasError && snapshot.data == null) {
              return Text('Something went wrong');
            }
            else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                if (snapshot.data!.docs[index]['Email'] == eml) {
                  print(eml);
                  print("yyyyyyyyyyy");
                return Column(
                  children: [
                    Container(
                        //height: sizeheight(context)*1.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('$imgpath/carbackground.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: 100,
                          ),
                          Container(
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          'Update Ride Info',
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      /*--------------------------------address---------------------------------------------*/
                                      Container(
                                        child: InkWell(
                                          onTap: () async {
                                            _handlePressButton(0);
                                          },
                                          child: TextFormField(
                                              enabled: false,
                                              validator: (input) {
                                                if (input == null) return 'Enter address';
                                              },
                                              
                                              controller: _pickupaddressController,
                                              decoration: InputDecoration(
                                                labelText: 'Set Pickup Address',
                                                hintText: snapshot.data!.docs[index]['pickupaddress'],
                                                prefixIcon: Icon(
                                                  Icons.location_on_outlined,
                                                ),
                                              ),
                                              onSaved: (input) => _name = input),
                                        ),
                                      ),
                                      /*--------------------------------address---------------------------------------------*/
                                      Container(
                                        child: InkWell(
                                          onTap: () async {
                                            _handlePressButton(1);
                                          },
                                          child: TextFormField(
                                              enabled: false,
                                              validator: (input) {
                                                if (input == null) return 'Enter address';
                                              },
                                              controller: _dropoffaddressController,
                                              decoration: InputDecoration(
                                                hintText: snapshot.data!.docs[index]['dropoffaddress'],
                                                labelText: 'Set Dropoff Address',
                                                prefixIcon: Icon(
                                                  Icons.location_on_outlined,
                                                ),
                                              ),
                                              onSaved: (input) => _name = input),
                                        ),
                                      ),
                          /*--------------------------------------Services----------------------------------------*/
                                      Container(
                                        child: TextFormField(
                                            validator: (input) {
                                              if (input == null) return 'Enter Service';
                                            },
                                            controller: _servicesController,
                                            decoration: InputDecoration(
                                              labelText: 'Car Type',
                                              hintText: snapshot.data!.docs[index]['services'],
                                              prefixIcon: Icon(
                                                Icons.car_rental,
                                              ),
                                            ),
                                            onSaved: (input) =>
                                                _servicesController.text = input!),
                                      ),
                                      /*--------------------------------------Services----------------------------------------*/
                                      Container(
                                        child: TextFormField(
                                            validator: (input) {
                                              if (input == null) return 'Enter Service';
                                            },
                                            controller: _carnoController,
                                            decoration: InputDecoration(
                                              labelText: 'Car No.',
                                              hintText: snapshot.data!.docs[index]['carno'],
                                              prefixIcon: Icon(
                                                Icons.car_rental,
                                              ),
                                            ),
                                            onSaved: (input) =>
                                                _servicesController.text = input!),
                                      ),
                                      Container(
                                        child: TextFormField(
                                          controller: _seatsController,
                                          decoration: InputDecoration(
                                            labelText: 'No. of Seats',
                                            prefixIcon: Icon(Icons.event_seat_sharp),
                                            hintText: snapshot.data!.docs[index]['seats'],
                                          ),
                                          validator: (input) {
                                            if (input == null)
                                              return 'Enter no. of seats';
                                          },
                                        ),
                                      ),
                                      RaisedButton(
                                        padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                                        onPressed: () async {
                                          
                                          },
                                        
                                        child: Text('Save Changes',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                        color: primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  ),
                                  ),
                        ],
                        ),
                        ),
                  ],
                );
                }
                else return SizedBox();
              }
            );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
                
          }
        ),
        );
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }

  Future<void> _handlePressButton(int id) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    var p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.overlay,
      language: "en",
      types: [],
      strictbounds: false,
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "pk")],
    );

    displayPrediction(p!, context, id);
  }

  Future<void> displayPrediction(
      Prediction p, BuildContext context, int id) async {
    if (p != null) {
      // get detail (lat/lng)

      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      if (id == 0) {
        setState(() {
          _pickupaddressController.text = p.description!;
          _originLatitude = lat;
          _originLongitude = lng;
          //   totalDistance = calculateDistance(
          //       _originLatitude, _originLongitude, _destLatitude, _destLongitude);
        });
      } else if (id == 1) {
        // if (_destinationController.text.isNotEmpty) {
        //   polylineCoordinates.clear();
        // }
        _dropoffaddressController.text = p.description!;
        _destLatitude = lat;
        _destLongitude = lng;
        // totalDistance = calculateDistance(
        //     _originLatitude, _originLongitude, _destLatitude, _destLongitude);
        // print('${totalDistance.truncate()} KM');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${p.description} - $lat/$lng")),
        );
      }
      // setMapPins();
      // _getPolyline();
      // setPolylines();
    }
  }

  // Calculate Distance in Km
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
