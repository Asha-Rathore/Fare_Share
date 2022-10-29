import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/bottomnav.dart';
import 'package:travelapp/models/sharing_ride_model.dart';
import 'package:travelapp/widgets/custome_button.dart';
import 'package:rating_dialog/rating_dialog.dart';

// ignore: must_be_immutable
class BookedRide extends StatefulWidget {
  SharingRideModel? pick;
  SharingRideModel? drop;
  BookedRide({Key? key, required this.pick, required this.drop})
      : super(key: key);

  @override
  _BookedRideState createState() => _BookedRideState();
}

class _BookedRideState extends State<BookedRide> {
  dynamic totaldis = 0;
  int count = 1;
  @override
  void initState() {
    calculateDistance(widget.pick!.latitude!, widget.pick!.longitude!,
        widget.drop!.latitude!, widget.drop!.longitude!);
    super.initState();
  }

  //Calculate Distance in Km
  void calculateDistance(
      _originLatitude, _originLongitude, _destLatitude, _destLongitude) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((_destLatitude - _originLatitude) * p) / 2 +
        c(_originLatitude * p) *
            c(_destLatitude * p) *
            (1 - c((_destLongitude - _originLongitude) * p)) /
            2;
    var dis = 12742 * asin(sqrt(a));
    setState(() {
      totaldis = dis.truncate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF21BFBD),
      backgroundColor: Colors.grey[800],
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => BottomNav()));
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => BottomNav()));
                  },
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Row(
                children: [
                  Text(
                    "Ride Confirmed",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 30.0,
                    ),
                  )
                ],
              )),
          SizedBox(height: 20.0),
          Container(
            height: MediaQuery.of(context).size.height - 135.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        top: 40.0, left: 20.0, right: 20.0),
                    child: Text(
                      "Ride in process",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Text(
                      "From",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Text(
                      widget.pick!.address!,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Text(
                      "To",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Text(
                      widget.drop!.address!,
                      // widget.drop,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Text(
                      "KM",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Text(
                      totaldis.toString(),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.left,
                    )),
                //
                Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Text(
                      "No Of Passengers",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                Row(
                  children: [
                    // Padding(
                    //     padding: const EdgeInsets.only(
                    //         top: 20.0, left: 20.0, right: 20.0),
                    //     child: Text(
                    //       "1",
                    //       style: TextStyle(
                    //         fontFamily: 'Montserrat',
                    //         fontSize: 18.0,
                    //       ),
                    //       textAlign: TextAlign.left,
                    //     )),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text(
                          //   "No of Passengers :",
                          //   style: TextStyle(
                          //     fontFamily: 'Montserrat',
                          //     fontSize: 17.0,
                          //   ),
                          // ),
                          MaterialButton(
                            onPressed: () {
                              if ((count >= 1) && (count <= 2) && count != 1) {
                                setState(() {
                                  count--;
                                });
                              }
                            },
                            child: Text(
                              '-',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: const CircleBorder(),
                            color: Colors.grey[800],
                          ),
                          Text(
                            '$count',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16.0,
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              if (count >= 1 && count <= 2 && count != 2) {
                                setState(() {
                                  count++;
                                });
                              }
                            },
                            child: Text(
                              '+',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: const CircleBorder(),
                            color: Colors.grey[800],
                          ),
                          
                        ],
                      ),
                    )
                  ],
                ),

                Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Text(
                      "Total Price",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Text(
                      (((totaldis * 15) + 80) * count).toString(),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.left,
                    )),
                //sd
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.0),
                  child: CustomeButton(
                    text: "Add Review & Rating",
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible:
                            true, // set to false if you want to force a rating
                        builder: (context) => _dialog,
                      );
                    },
                    color: Colors.grey.shade800,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  final _dialog = RatingDialog(
    initialRating: 1.0,
    // your app's name?
    title: Text(
      'Rating Dialog',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    // message: Text(
    //   'Tap a star to set your rating. Add more description here if you want.',
    //   textAlign: TextAlign.center,
    //   style: const TextStyle(fontSize: 15),
    // ),
    // your app's logo?
    //image: const FlutterLogo(size: 100),
    submitButtonText: 'Submit',
    commentHint: 'Set your custom comment hint',
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) {
      print('rating: ${response.rating}, comment: ${response.comment}');

      // TODO: add your own logic
      if (response.rating < 3.0) {
        //save firebase
        print(response.rating);
        print(response.comment);
        // send their comments to your email or anywhere you wish
        // ask the user to contact you instead of leaving a bad review
      } else {
        //_rateAndReviewApp();
      }
    },
  );
}
