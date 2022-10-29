import 'dart:developer';
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
import 'package:travelapp/Screens/login_driver_screen.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/Utils/extensions.dart';
import 'package:travelapp/services/database_helper.dart';
import 'package:travelapp/widgets/custome_snackbar.dart';

//import 'package:meconline/HomePage.dart';
//Saving Token

Future<void> saveTokenToDatabase(String token) async {
  // Assume user is logged in for this example
  // String userId = FirebaseAuth.instance.currentUser!.uid;
  // print("device userId is created ${userId}");
  //var data = await FirebaseFirestore.instance.collection('Drivers').doc().get();
  //print(data);
  await FirebaseFirestore.instance
      .collection('Drivers')
      .doc("342312345")
      .update({
    'tokens': //token,
        FieldValue.arrayUnion([token]),
  });
}

class SignUpDriverPage extends StatefulWidget {
  @override
  _SignUpDriverPageState createState() => _SignUpDriverPageState();
}

class _SignUpDriverPageState extends State<SignUpDriverPage> {
  var locationMessage = '';
  String? latitude;
  String? longitude;
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

  late String _token;
//  setupToken();
  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();
    log("device token is created ${token}");
    // Save the initial token to the database
    await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pickupaddressController =
      TextEditingController();
  final TextEditingController _dropoffaddressController =
      TextEditingController();
  final TextEditingController _servicesController = TextEditingController();
  final TextEditingController _carnoController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  String? dropdownvalue = "Select Service";
  //int var = int.parse(_seatsController.text);
  var kGoogleApiKey = "AIzaSyDHZomR5ozaTualggVoaq5Z2fZIFC_03eQ";
  double _originLatitude = 0.0, _originLongitude = 0.0;
  double _destLatitude = 0.0, _destLongitude = 0.0;
  String? _email, _password, _name;

  var pickup, dropoff;
  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phonenoController.dispose();
    _cityController.dispose();
    _pickupaddressController.dispose();
    _dropoffaddressController.dispose();
    _servicesController.dispose();
    _seatsController.dispose();
    _carnoController.dispose();
    
    super.dispose();
  }

  clearTextInput() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    _phonenoController.clear();
    _cityController.clear();
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
        body: SingleChildScrollView(
          child: Container(
              //height: sizeheight(context)*1.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('$imgpath/carbackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Icon(
                  Icons.how_to_reg,
                  size: 200,
                  color: primaryColor,
                ),
                Container(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Driver Register',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            /*--------------------------------name---------------------------------------------*/
                            Container(
                              child: TextFormField(
                                // ignore: missing_return
                                controller: _nameController,

                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (input) {
                                  if (input == null) return 'Enter Name';
                                },
                              ),
                            ),
                            /*--------------------------------phoneno---------------------------------------------*/
                            Container(
                              child: TextFormField(
                                controller: _phonenoController,
                                decoration: InputDecoration(
                                  labelText: 'WhatsApp Number',
                                  prefixIcon: Icon(Icons.phone_missed_sharp),
                                ),
                                validator: (input) {
                                  if (input == null) return 'Enter Number';
                                },
                              ),
                            ),
                            /*--------------------------------city---------------------------------------------*/
                            Container(
                              child: TextFormField(
                                validator: (input) {
                                  if (input == null) return 'Enter City';
                                },
                                controller: _cityController,
                                decoration: InputDecoration(
                                  labelText: 'City',
                                  prefixIcon: Icon(Icons.location_city),
                                ),
                                // onSaved: (input) => _name = input),
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
                                      labelText: 'Set Address',
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
                                    prefixIcon: Icon(
                                      Icons.car_rental,
                                    ),
                                  ),
                                  onSaved: (input) =>
                                      _servicesController.text = input!),
                            ),
                            /*--------------------------------email---------------------------------------------*/
                            Container(
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email)),
                                validator: (String? v) {
                                  if (v!.isValidEmail) {
                                    return null;
                                  } else {
                                    return "Please enter a valid email";
                                  }
                                },
                              ),
                            ),
                            /*--------------------------------password---------------------------------------------*/
                            Container(
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                obscureText: true,
                                validator: (String? v) {
                                  if (v!.isValidPassword) {
                                    return null;
                                  } else {
                                    return "Password must contain an uppercase, lowercase, numeric digit and special character ";
                                  }
                                },
                              ),
                            ),
                            Container(
                              child: TextFormField(
                                controller: _seatsController,
                                decoration: InputDecoration(
                                  labelText: 'No. of Seats',
                                  prefixIcon: Icon(Icons.event_seat_sharp),
                                ),
                                validator: (input) {
                                  if (input == null)
                                    return 'Enter no. of seats';
                                },
                              ),
                            ),
                            Container(
                              child: DropdownButtonFormField<String>(
                                //value: dropdownvalue,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.emoji_transportation),
                                ),
                                hint: Text('Select Service'),
                                items: <String>[
                                  'Daily Rides',
                                  'Intercity',
                                  'Event'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    dropdownvalue = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            // ignore: deprecated_member_use
                            RaisedButton(
                              padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String? devicetoken = await FirebaseMessaging
                                      .instance
                                      .getToken();
                                  if (_nameController.text.isNotEmpty &&
                                      _phonenoController.text.isNotEmpty &&
                                      _cityController.text.isNotEmpty &&
                                      _servicesController.text.isNotEmpty &&
                                      _emailController.text.isNotEmpty &&
                                      _passwordController.text.isNotEmpty &&
                                      _seatsController.text.isNotEmpty &&
                                      _carnoController.text.isNotEmpty &&
                                      dropdownvalue != "Select Service") {
                                    if (((int.parse(_seatsController.text)) <=
                                                3 &&
                                            (dropdownvalue == "Daily Rides" ||
                                                dropdownvalue ==
                                                    "Intercity")) ||
                                        ((int.parse(_seatsController.text)) >=
                                                3 &&
                                            (int.parse(_seatsController.text)) <
                                                7 &&
                                            (dropdownvalue == "Event" ||
                                                dropdownvalue ==
                                                    "Intercity")) ||
                                        ((int.parse(_seatsController.text)) >=
                                                7 &&
                                            (dropdownvalue == "Event" ||
                                                dropdownvalue ==
                                                    "Intercity"))) {
                                                      await Database.addDriverDetails(
                                      name: _nameController.text,
                                      phono: _phonenoController.text,
                                      city: _cityController.text,
                                      address:
                                          _pickupaddressController.text,
                                      // dropoffaddress:
                                      //     _dropoffaddressController.text,
                                      services: _servicesController.text,
                                      carno: _carnoController.text,
                                      Email: _emailController.text,
                                      password: _passwordController.text,
                                      latitude: double.parse(latitude!),
                                      longitude: double.parse(longitude!),
                                      seats: int.parse(_seatsController.text),
                                      servicetype: dropdownvalue,
                                      token: devicetoken,
                                    );
                                    //_showMessageInScaffold("Registered Successfully${locationMessage}");
                                    _showMessageInScaffold(
                                        "Registered Successfully");
                                    _register();
                                  } else {
                                    _showMessageInScaffold(
                                        "Please Fill all Fields");
                                  }
                                                    }
                                  //   else if (dropdownvalue == 'Sharing' &&
                                  //       _pickupaddressController
                                  //           .text.isNotEmpty &&
                                  //       _dropoffaddressController
                                  //           .text.isNotEmpty) {
                                  //             await Database.addDriverDetails(
                                  //     name: _nameController.text,
                                  //     phono: _phonenoController.text,
                                  //     city: _cityController.text,
                                  //     address:
                                  //         _pickupaddressController.text,
                                  //     services: _servicesController.text,
                                  //     carno: _carnoController.text,
                                  //     Email: _emailController.text,
                                  //     password: _passwordController.text,
                                  //     latitude: double.parse(latitude!),
                                  //     longitude: double.parse(longitude!),
                                  //     seats: int.parse(_seatsController.text),
                                  //     servicetype: dropdownvalue,
                                  //     token: devicetoken,
                                  //   );
                                  //   //_showMessageInScaffold("Registered Successfully${locationMessage}");
                                  //   _showMessageInScaffold(
                                  //       "Registered Successfully");
                                  //   _register();
                                  // } 
                                  else {
                                    _showMessageInScaffold(
                                        "Please Fill all Fields");
                                  }
                                            }
                            
                                },
                              
                              child: Text('SignUp',
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
        ),
        );
  }

  //register void function
  void _register() async {
    print("------------------register enters screen");
    final user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      print("----------------success");
      clearTextInput();

      setState(() {
        _success = true;
        _mechemail = user.email;
      });
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => DriverLoginPage()));
      });
    } else {
      setState(() {
        _success = true;
      });
    }
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
