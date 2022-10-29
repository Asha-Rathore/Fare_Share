import 'package:flutter/material.dart';
import 'package:travelapp/bottomnav.dart';
import 'package:travelapp/home.dart';

class SeatConfirmed extends StatefulWidget {
  @override
  _SeatConfirmedState createState() => _SeatConfirmedState();
}

class _SeatConfirmedState extends State<SeatConfirmed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF21BFBD),
      backgroundColor: Colors.grey[800],
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => BottomNav()));
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
          Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Row(
                children: [
                  Text(
                    "Seat Confirmed",
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
              height: MediaQuery.of(context).size.height - 145.0,
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
                        "Your Seat has been confirmed",
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
                        "Driver will reach on given date.",
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
                        "Thank You.",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.left,
                      )),

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
              ))
        ],
      ),
    );
  }
}
