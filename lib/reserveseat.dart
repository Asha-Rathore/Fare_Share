import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import 'package:google_maps_webservice/places.dart';

import 'package:travelapp/bottomnav.dart';

import 'package:travelapp/widgets/polyline_widget.dart';
import 'package:intl/intl.dart';

class ReserveSeatPage extends StatefulWidget {
  String? dirverId;
  ReserveSeatPage({Key? key, this.dirverId}) : super(key: key);

  @override
  _ReserveSeatPageState createState() => _ReserveSeatPageState();
}

class _ReserveSeatPageState extends State<ReserveSeatPage> {
  TextEditingController _pickupController = TextEditingController();
  TextEditingController _dropoffController = TextEditingController();
  TextEditingController _comments = TextEditingController();
  String vehicle1 = "1-7 Seater Vehicle-Land Cruiser";
  String vehicle2 = "5-7 Seater Vehicle -Suzuki Hi-roof";
  String vehicle3 = "8-14 Seater Vehicle - Toyota Hiace";
  final formKey = GlobalKey<FormState>();

  var kGoogleApiKey = "AIzaSyDHZomR5ozaTualggVoaq5Z2fZIFC_03eQ";
  double _originLatitude = 0.0, _originLongitude = 0.0;
  double _destLatitude = 0.0, _destLongitude = 0.0;
  double? _height;
  double? _width;

  String? _setTime, _setDate;

  String? _hour, _minute, _time;

  String? dateTime;
  bool checkbox1 = false;
  bool checkbox2 = false;
  bool checkbox3 = false;

  late String time;
  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  String getText() {
    if (selectedTime == null) {
      return "Select Time";
    } else {
      String selTime = selectedTime.hour.toString().padLeft(2, '0') +
          ':' +
          selectedTime.minute.toString().padLeft(2, '0') +
          ':00';
      time = DateFormat.jm().format(DateFormat("hh:mm:ss").parse(selTime));
      return time; //DateFormat.jm().format(DateFormat("hh:mm:ss").parse(selTime));

    }
  }

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        //initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2023));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (newTime == null) return;

    setState(() => selectedTime = newTime);
  }

  // Future<Null> _selectTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: selectedTime,
  //   );
  //   if (picked != null)
  //     setState(() {
  //       selectedTime = picked;
  //       _hour = selectedTime.hour.toString();
  //       _minute = selectedTime.minute.toString();
  //       _time = _hour! + ' : ' + _minute!;
  //       _timeController.text = _time!;
  //       _dateController.text = DateTime.now().toString();
  //       // _timeController.text = formatDate(
  //       //     DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
  //       //     [hh, ':', nn, " ", am]).toString();
  //     });
  // }

  @override
  void initState() {
    //  _controller1 = TextEditingController(text: DateTime.now().toString());
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    //_timeController.text = formatDate(
    // DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
    // [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
      // backgroundColor: Color(0xFF21BFBD),
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNav(),
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                "Reserve Your Seat",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                  //height: MediaQuery.of(context).size.height - 145.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _handlePressButton(0);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 20.0, right: 20.0),
                            child: TextFormField(
                              controller: _pickupController,
                              enabled: false,
                              decoration: InputDecoration(
                                  labelText: 'Pickup Location',
                                  hoverColor: Colors.teal[200]),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter Pickup Location";
                                } else {
                                  return null;
                                }
                              },
                              // showCursor: true,
                              // readOnly: true,
                              // onChanged: (value) {
                              //   print(value);
                              // },
                              // onTap: () {
                              //   Navigator.push(context, MaterialPageRoute(
                              //                     builder: (context) => LocationScreen(),
                              //                     ),
                              //                   );
                              // },
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _handlePressButton(1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0,
                                left: 20.0,
                                right: 20.0,
                                bottom: 20.0),
                            child: TextFormField(
                              enabled: false,
                              controller: _dropoffController,
                              decoration: InputDecoration(
                                  labelText: 'Drop Off Location',
                                  hoverColor: Colors.teal[200]),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter Drof off Location";
                                } else {
                                  return null;
                                }
                              },
                              // showCursor: true,
                              // readOnly: true,
                              onChanged: (value) {
                                print(value);
                              },
                              // onTap: () {
                              //   Navigator.push(context, MaterialPageRoute(
                              //                     builder: (context) => LocationScreen(),
                              //                     ),
                              //                   );
                              // },
                            ),
                          ),
                        ),
                        //
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Select Date',
                            style: TextStyle(
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                fontFamily: 'Montserrat',
                                fontSize: 18.0),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                            width: _width! / 1.3,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                              ),
                              textAlign: TextAlign.center,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: _dateController,
                              onSaved: (String? val) {
                                print(_setDate);
                                _setDate = val!;
                              },
                              decoration: InputDecoration(
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  // labelText: 'Time',
                                  contentPadding: EdgeInsets.only(top: 0.0)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Select Time',
                            style: TextStyle(
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                fontFamily: 'Montserrat',
                                fontSize: 18.0),
                          ),
                        ),
                        InkWell(
                          onTap: () => pickTime(context),
                          child: Container(
                            width: _width! / 1.3,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Text(
                              getText(),
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                              ),
                              textAlign: TextAlign.center,
                              // enabled: false,
                              // keyboardType: TextInputType.text,
                              // controller: getText(),
                              // onSaved: (String? val) {
                              //   print(_setDate);
                              //   _setDate = val!;
                              // },
                              // decoration: InputDecoration(
                              //     disabledBorder: UnderlineInputBorder(
                              //         borderSide: BorderSide.none),
                              //     // labelText: 'Time',
                              //     contentPadding: EdgeInsets.only(top: 0.0)),
                            ),
                          ),
                        ),
                        //
                        //
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              // width: 100,
                              height: 60,

                              child: Card(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Checkbox(
                                        value: checkbox1,
                                        /* this.value */
                                        onChanged: (bool? value) {
                                          print(bool);
                                          setState(() {
                                            checkbox1 = value!;
                                            if (checkbox2 == true &&
                                                checkbox3 == true) {
                                              checkbox2 = false;
                                              checkbox3 = false;
                                            } else if (checkbox2) {
                                              checkbox2 = false;
                                            } else if (checkbox3) {
                                              checkbox3 = false;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      '1-7 Seater Vehicle-Land Cruiser',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ), //Checkbox
                                  ], //<Widget>[]
                                ), //Padding
                              ),
                            ),
                          ),
                        ),
                        //
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              // width: 100,
                              height: 60,

                              child: Card(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Checkbox(
                                        value: checkbox2,
                                        /* this.value */
                                        onChanged: (bool? value) {
                                          print(bool);
                                          setState(() {
                                            checkbox2 = value!;
                                            if (checkbox1 == true &&
                                                checkbox3 == true) {
                                              checkbox1 = false;
                                              checkbox3 = false;
                                            } else if (checkbox1) {
                                              checkbox1 = false;
                                            } else if (checkbox3) {
                                              checkbox3 = false;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      '5-7 Seater Vehicle -Suzuki Hi-roof',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ), //Checkbox
                                  ], //<Widget>[]
                                ), //Padding
                              ),
                            ),
                          ),
                        ),
                        //
                        //
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              // width: 100,
                              height: 60,

                              child: Card(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      child: Checkbox(
                                        value: checkbox3,
                                        /* this.value */
                                        onChanged: (bool? value) {
                                          setState(() {
                                            checkbox3 = value!;
                                            if (checkbox1 == true &&
                                                checkbox2 == true) {
                                              checkbox1 = false;
                                              checkbox2 = false;
                                            } else if (checkbox1) {
                                              checkbox1 = false;
                                            } else if (checkbox2) {
                                              checkbox2 = false;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      '8-14 Seater Vehicle - Toyota Hiace',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ), //Checkbox
                                  ], //<Widget>[]
                                ), //Padding
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              child: Text(
                                "Comments (Optional)",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0, bottom: 25.0),
                              child: TextFormField(
                                controller: _comments,
                                minLines: 2,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                if ((checkbox1 || checkbox2 || checkbox3) &&
                                    (formKey.currentState!.validate())) {
                                  if (checkbox1) {
                                    print(vehicle1);
                                    var totalDistance = calculateDistance(
                                        _originLatitude,
                                        _originLongitude,
                                        _destLatitude,
                                        _destLongitude);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DrawPolyLine(
                                                  originLatitude:
                                                      _originLatitude,
                                                  originLongitude:
                                                      _originLongitude,
                                                  destLatitude: _destLatitude,
                                                  destLongitude: _destLongitude,
                                                  totlaDistance: totalDistance,
                                                  pickupLocation:
                                                      _pickupController.text,
                                                  dropOffLocation:
                                                      _dropoffController.text,
                                                  comment: _comments.text,
                                                  pickupDateTime:
                                                      _dateController.text,
                                                  vehicleType: vehicle1,
                                                  pickuptime: time,
                                                  driverid: widget.dirverId,
                                                )));
                                  } else if (checkbox2) {
                                    print(vehicle2);
                                    var totalDistance = calculateDistance(
                                        _originLatitude,
                                        _originLongitude,
                                        _destLatitude,
                                        _destLongitude);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            DrawPolyLine(
                                          originLatitude: _originLatitude,
                                          originLongitude: _originLongitude,
                                          destLatitude: _destLatitude,
                                          destLongitude: _destLongitude,
                                          totlaDistance: totalDistance,
                                          pickupLocation:
                                              _pickupController.text,
                                          dropOffLocation:
                                              _dropoffController.text,
                                          comment: _comments.text,
                                          pickupDateTime: _dateController.text,
                                          vehicleType: vehicle2,
                                          pickuptime: time,
                                          driverid: widget.dirverId,
                                        ),
                                      ),
                                    );
                                  } else {
                                    print(vehicle3);
                                    var totalDistance = calculateDistance(
                                        _originLatitude,
                                        _originLongitude,
                                        _destLatitude,
                                        _destLongitude);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DrawPolyLine(
                                                  originLatitude:
                                                      _originLatitude,
                                                  originLongitude:
                                                      _originLongitude,
                                                  destLatitude: _destLatitude,
                                                  destLongitude: _destLongitude,
                                                  totlaDistance: totalDistance,
                                                  pickupLocation:
                                                      _pickupController.text,
                                                  dropOffLocation:
                                                      _dropoffController.text,
                                                  comment: _comments.text,
                                                  pickupDateTime:
                                                      _dateController.text,
                                                  vehicleType: vehicle3,
                                                  pickuptime: time,
                                                  driverid: widget.dirverId,
                                                ),
                                                )
                                              );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text("Please fill all required fields"),
                                    duration: Duration(seconds: 2),
                                  ));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 18.0),
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 18.0),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.0),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }

  //Polyline
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
          _pickupController.text = p.description!;
          _originLatitude = lat;
          _originLongitude = lng;
          print("+++++++++++++++++++++++");
          print(p.description);
          //   totalDistance = calculateDistance(
          //       _originLatitude, _originLongitude, _destLatitude, _destLongitude);
        });
      } else if (id == 1) {
        // if (_destinationController.text.isNotEmpty) {
        //   polylineCoordinates.clear();
        // }
        _dropoffController.text = p.description!;
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
