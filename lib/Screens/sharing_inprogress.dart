import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travelapp/Screens/history.dart';
import 'package:travelapp/Utils/constants.dart';

class SharingHistory extends StatefulWidget {
  String? currentUserEmail;
  SharingHistory({Key? key, this.currentUserEmail}) : super(key: key);

  @override
  _SharingHistoryState createState() => _SharingHistoryState();
}

class _SharingHistoryState extends State<SharingHistory> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    print(widget.currentUserEmail);
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => HistoryPage()));
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
        backgroundColor: Colors.grey[800],
        title: new Text(
          "In Progress History",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        toolbarHeight: 70.0,
        elevation: 5.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('Sharing').snapshots(),
          builder: (context, citySnapshot) {
            return citySnapshot.hasData
                ? ListView.builder(
                    itemCount: citySnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot cityData =
                          citySnapshot.data!.docs[index];
                      return cityData.id == widget.currentUserEmail
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10.0),
                              child: Container(
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "In Progress",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w100,
                                              color: Colors.black),
                                        ),
                                      ),
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
                                            width: sizeWidth(context) * 0.7,
                                            // width: 70,
                                            child: Text(
                                              cityData['from'],
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w100,
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
                                            width: sizeWidth(context) * 0.7,
                                            child: Text(
                                              // "PAF-KIET Main Campus Karachi",
                                              cityData['destination'],
                                              // snapshot.data!.docs[index]
                                              //     ['dropOffLoacation'],
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w100,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.card_travel,
                                            color: Colors.black,
                                            size: 25.0,
                                          ),
                                          SizedBox(width: 5.0),
                                          Container(
                                            width: 250,
                                            child: Text(
                                              // "PAF-KIET Main Campus Karachi",
                                              "${cityData['totalDistance']} KM",

                                              // snapshot.data!.docs[index]
                                              //     ['vehicleType'],
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w100,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.group_rounded,
                                            color: Colors.black,
                                            size: 25.0,
                                          ),
                                          SizedBox(width: 5.0),
                                          Container(
                                            width: 250,
                                            child: Text(
                                              // "PAF-KIET Main Campus Karachi",
                                              "${cityData['passengers']} passenger(s)",

                                              // snapshot.data!.docs[index]
                                              //     ['vehicleType'],
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w100,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              // "RS 785",
                                              "Rs. ${cityData['totalPrice'].toInt()}",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w100,
                                                  color: Colors.black),
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.fade,
                                              maxLines: 2,
                                              softWrap: false,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${DateTime.parse(cityData['dateTime'].toDate().toString())}",
                                              // cityData['dateTime'],
                                              // snapshot.data!.docs[index]
                                              //     ['pickupDateTime'],
                                              // "1/14/2022 3:18 PM",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w100,
                                                  color: Colors.black),
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.fade,
                                              maxLines: 2,
                                              softWrap: false,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox();
                    },
                  )
                : CircularProgressIndicator();
          }),

      //---------------------------------------------------------Future end
    );
  }
}
