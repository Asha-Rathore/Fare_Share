import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/Screens/admin_main_page.dart';
import 'package:travelapp/Screens/history.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/services/database_helper.dart';

class AdminHomePage extends StatefulWidget {
  String? currentUserEmail;
  AdminHomePage({Key? key, this.currentUserEmail}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
    String? phoneno;
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUserEmail();
    super.initState();
  }

  getCurrentUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    var stringValue = prefs.getString('phono');
    setState(() {
      phoneno = stringValue;
    });
    // return stringValue;
  }
  @override
  Widget build(BuildContext context) {
    final heigh=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    print(widget.currentUserEmail);
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => AdminMainPage()));
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
        backgroundColor: Colors.grey[800],
        title: new Text(
          "Drivers",
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
              .collection('Drivers')
              .snapshots(),
              
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      // DocumentSnapshot cityData =
                      //     snapshot.data!.docs[index];
                      //     print(cityData.id);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10.0),
                        child: Container(
                          height: heigh*0.37,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Driver",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.black),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.email_rounded,
                                      color: Colors.black,
                                      size: 25.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    Container(
                                      width: sizeWidth(context) * 0.7,
                                      // width: 70,
                                      child: Text(
                                        // "PAF-KIET Main Campus Karachi",
                                        snapshot.data!.docs[index]['Email'],
                                        //  cityData.data!.docs[index]
                                        //  ['pickUpLocation'],
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.person_rounded,
                                      color: Colors.black,
                                      size: 25.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    Container(
                                      width: sizeWidth(context) * 0.7,
                                      child: Text(
                                        // "PAF-KIET Main Campus Karachi",
                                        snapshot.data!.docs[index]['name'],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.drive_eta_rounded,
                                      color: Colors.black,
                                      size: 25.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    Container(
                                      width: 250,
                                      child: Text(
                                        // "PAF-KIET Main Campus Karachi",
                                        snapshot.data!.docs[index]['services'],

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_city_rounded,
                                      color: Colors.black,
                                      size: 25.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    Container(
                                      width: 250,
                                      child: Text(
                                        // "PAF-KIET Main Campus Karachi",
                                        snapshot.data!.docs[index]['city'],

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
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Icon(
                                //       Icons.location_on,
                                //       color: Colors.black,
                                //       size: 25.0,
                                //     ),
                                //     SizedBox(width: 5.0),
                                //     Container(
                                //       width: 250,
                                //       child: Text(
                                //         // "PAF-KIET Main Campus Karachi",
                                //         snapshot.data!.docs[index]['address'],

                                //         // snapshot.data!.docs[index]
                                //         //     ['vehicleType'],
                                //         style: TextStyle(
                                //             fontFamily: 'Montserrat',
                                //             fontSize: 15.0,
                                //             fontWeight: FontWeight.w100,
                                //             color: Colors.black),
                                //       ),
                                //     ),
                                    
                                //   ],
                                // ),
                                SizedBox(height: 8.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.phone_rounded,
                                      color: Colors.black,
                                      size: 25.0,
                                    ),
                                    SizedBox(width: 5.0),
                                    Container(
                                      width: 250,
                                      child: Text(
                                        // "PAF-KIET Main Campus Karachi",
                                        snapshot.data!.docs[index]['phoneno'],

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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        FirebaseFirestore.instance
                                        .collection('Drivers')
                                        .doc(snapshot.data!.docs[index].id)
                                        .delete();
                                        // .then((value) {
                                        //   if (snapshot.data!.docs.length == 1)
                                        //   FirebaseFirestore.instance
                                        //   .collection(collectionPath);
                                        // }
                                        // );
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w300),
                                      ),
                                      style: ButtonStyle(
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey[800]),
                            ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Block",
                                        style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w300),
                                      ),
                                      style: ButtonStyle(
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey[800]),
                            ),
                                    )
                                  ],
                                )
                                
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.all(6.0),
                                //       child: Text(
                                //         // "RS 785",
                                //         snapshot.data!.docs[index]['city'],
                                //         style: TextStyle(
                                //             fontFamily: 'Montserrat',
                                //             fontSize: 15.0,
                                //             fontWeight: FontWeight.w100,
                                //             color: Colors.black),
                                //         textAlign: TextAlign.left,
                                //         overflow: TextOverflow.fade,
                                //         maxLines: 2,
                                //         softWrap: false,
                                //       ),
                                //     ),
                                //     Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Text(
                                //         snapshot.data!.docs[index]['address'],
                                //         // snapshot.data!.docs[index]
                                //         //     ['pickupDateTime'],
                                //         // "1/14/2022 3:18 PM",
                                //         style: TextStyle(
                                //             fontFamily: 'Montserrat',
                                //             fontSize: 15.0,
                                //             fontWeight: FontWeight.w100,
                                //             color: Colors.black),
                                //         textAlign: TextAlign.left,
                                //         overflow: TextOverflow.fade,
                                //         maxLines: 2,
                                //         softWrap: false,
                                //       ),
                                //     ),
                                //     Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Text(
                                //         snapshot.data!.docs[index]['services'],
                                //         // snapshot.data!.docs[index]
                                //         //     ['pickupDateTime'],
                                //         // "1/14/2022 3:18 PM",
                                //         style: TextStyle(
                                //             fontFamily: 'Montserrat',
                                //             fontSize: 15.0,
                                //             fontWeight: FontWeight.w100,
                                //             color: Colors.black),
                                //         textAlign: TextAlign.left,
                                //         overflow: TextOverflow.fade,
                                //         maxLines: 2,
                                //         softWrap: false,
                                //       ),
                                //     ),
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : CircularProgressIndicator();
          }),

      //---------------------------------------------------------Future end
    );
  }
}
