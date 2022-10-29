import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:travelapp/bottomnav.dart';
import 'package:travelapp/services/database_helper.dart';
import 'package:travelapp/widgets/custome_button.dart';
import 'package:travelapp/widgets/custome_snackbar.dart';

class RideConfirmed extends StatefulWidget {

  @override
  _RideConfirmedState createState() => _RideConfirmedState();
}

class _RideConfirmedState extends State<RideConfirmed> {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // backgroundColor: Color(0xFF21BFBD),
      backgroundColor: Colors.grey[800],
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              left: 10.0
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => BottomNav()));
                  }, 
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                )
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.only(left: 30.0),
            child: Row(
              children: [
                Text(
                  "In Progress",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                )
              ],
            )
          ),
          SizedBox(height: 20.0),
          Container(
            height: MediaQuery.of(context).size.height - 145.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                    child: Text(
                      "Ride in process",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.left,
                      )
                  ),
                // Padding(
                //     padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                //     child: Text(
                //       "Ride in process",
                //         style: TextStyle(
                //           fontFamily: 'Montserrat',
                //           fontSize: 18.0,
                            
                //         ),
                //         textAlign: TextAlign.left,
                //       )
                //   ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                    child: Text(
                      
                      "Thank You.",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          
                        ),
                        textAlign: TextAlign.left,
                      )
                  ),
                // SizedBox(height: 8.0),
                //       Align(
                //         alignment: Alignment.topCenter,
                //         child: Padding(
                //           padding: const EdgeInsets.only(bottom: 10.0),
                //           child: ElevatedButton(
                //             onPressed: () async {
                //               setState(() {
                //                 now = DateTime.now();
                //                 time = DateFormat('dd-MM-yyyy').format(now);
                //                 flag = true;
                //               });
                //               flag = true;
                //               SharedPreferences prefs =
                //                   await SharedPreferences.getInstance();
                //               //Return String
                //               var userEmail = prefs.getString('useremail');

                //               // add data in db of dailyrides
                //               await Database.addDailyRide(
                //                   from: widget.origin,
                //                   destination: widget.destination,
                //                   totalDistance: widget.totalDistance,
                //                   totalPrice: widget.totalPrice,
                //                   dateTime: now,
                //                   driverid: widget.phone,
                //                   email: userEmail,
                //                   userid: userEmail,
                //                   flag: flag);
                //               CustomSnacksBar.showSnackBar(
                //                   context, "Request Send Successfully");
                //               // _showMessageInScaffold("Request Send Successfully");
                //               // String? token =
                //               //     "cBVGGIEkSseAn_rpZJvSGI:APA91bF4Znmpz7mRuRdwJjNLlpg1pzvM19E25-8Wv8phbNb_qgeqjE7F6rxoO-BbjGOe4AQ7ikNF52QMCpDV5jtCFcL0Duqoq7L1IIooUHecsYzu6jcSNlgu6pMtot0jA4tSoMBYZvGY";
                //               // _showNotification();
                //               // FirebaseFirestore.instance
                //               //     .collection('UsersData')
                //               //     .doc(FirebaseAuth.instance.currentUser!.email)
                //               //     .set({}, SetOptions(merge: true));
                //               // sendNotification('Trip', token!);
                //               // _showMessageInScaffold("Ride Conform Successfully");
                //               //add data end
                //               Future.delayed(Duration(seconds: 5), () {
                //                 // 5s over, navigate to a new page
                //                 Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) => RideConfirmed()),
                //                 );
                //               });
                //             },
                //             child: Padding(
                //               padding: const EdgeInsets.only(
                //                   top: 17.0,
                //                   bottom: 17.0,
                //                   left: 40.0,
                //                   right: 40.0),
                //               child: Text(
                //                 'Confirm Ride',
                //                 style: TextStyle(
                //                     color: Colors.white,
                //                     fontSize: 15.0,
                //                     fontFamily: 'Montserrat',
                //                     fontWeight: FontWeight.w300),
                //               ),
                //             ),
                //             style: ButtonStyle(
                //               shape: MaterialStateProperty.all<
                //                   RoundedRectangleBorder>(RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(18.0),
                //               )),
                //               backgroundColor:
                //                   MaterialStateProperty.all(Colors.grey[800]),
                //             ),
                //           ),
                //         ),
                //       ),
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

                // Padding(
                //     padding: const EdgeInsets.only(top: 100.0, left: 70.0),
                //     child: ElevatedButton(
                //       onPressed: () {
                        
                //       },
                //       child: Padding(
                //         padding: const EdgeInsets.only(top: 17.0, bottom: 17.0, left: 40.0, right: 40.0),
                //           child: Text(
                //             'Confirm Ride',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 15.0,
                //               fontFamily: 'Montserrat',
                //               fontWeight: FontWeight.w300
                //             ),
                //           ),
                //         ),
                //         style: ButtonStyle(
                //           shape:  MaterialStateProperty.all<RoundedRectangleBorder>(
                //             RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(18.0),
                //             )
                //           ),
                //           backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
                //         ),
                //       ),
                //   ),
              ],
            )
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