import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/Screens/collect_cash_screen.dart';
import 'package:travelapp/Screens/main_screen.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/notification.dart';
import 'package:travelapp/services/database_helper.dart';

import 'Screens/history.dart';

class ProPage extends StatefulWidget {
  const ProPage({Key? key}) : super(key: key);

  @override
  _ProPageState createState() => _ProPageState();
}

class _ProPageState extends State<ProPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF21BFBD),
//       body:Center(child: Text("Support")),
//     );
//   }
// }

  @override
  void initState() {
    //getCurrentLocation();
    getStringValuesSF();
    super.initState();
  }

  var locationMessage = '';
  String? latitude;
  String? longitude;
  String? eml;
  void getCurrentLocation() async {
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

  @override
  Widget build(BuildContext context) {
    bool _checkbox = false;

    final double btnmargsize = MediaQuery.of(context).size.width * 0.09;
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[800],
        title: new Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        toolbarHeight: 70.0,
        elevation: 5.0,
      ),
      drawer: SafeArea(
        child: new Drawer(
          child: StreamBuilder<QuerySnapshot>(
            stream: Database.readuserdata(),
            builder: (context, snapshot) {
              if (snapshot.hasError && snapshot.data == null) {
                return Text('Something went wrong');
              } else if (snapshot.hasData || snapshot.data != null) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data!.docs[index]['UEmail'] == eml) {
                        return Column(
                          children: [
                            Container(
                              height: 200,
                              width: sizeWidth(context),
                              color: Colors.grey[800],
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "User",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['uname'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['UEmail'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  // new ListTile(
                                  //   title: new Text(
                                  //     'Profile',
                                  //     style: TextStyle(
                                  //       color: Colors.black,
                                  //       fontFamily: 'Montserrat',
                                  //     ),
                                  //   ),
                                  //   trailing: new Icon(Icons.account_box),
                                  // ),
                                  new ListTile(
                                    title: new Text(
                                      'About Us',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                    trailing: new Icon(Icons.info_outline_rounded),
                                    onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        NotifPage()));
                                      }
                                  ),
                                  new ListTile(
                                      title: new Text(
                                        'Wallet',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      trailing: new Icon(Icons.wallet_rounded),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        WalletPage()));
                                      }),
                                  new ListTile(
                                      title: new Text(
                                        'History',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      trailing: new Icon(Icons.history_rounded),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        HistoryPage()));
                                      }),
                                  new ListTile(
                                      title: new Text(
                                        'Sign out',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      trailing: new Icon(Icons.close),
                                      //onTap: ()=>Navigator.of(context).pop(),
                                      onTap: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await //prefs?.clear();
                                            prefs.clear();
                                        await prefs.remove('useremail');
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        MainScreen()));
                                      })
                                ],
                              ),
                            ),
                          ],
                        );
                      } else
                        return SizedBox();
                    });
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
      body: Container(
        //carmech1
        height: sizeheight(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.darken),
            image: AssetImage('$imgpath/carbackground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
              stream: Database.readuserdata(),
              builder: (context, snapshot) {
                if (snapshot.hasError && snapshot.data == null) {
                  return Text('Something went wrong');
                } else if (snapshot.hasData || snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data!.docs[index]['UEmail'] == eml) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                //mainAxisAlignment:
                                //MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: 15),
                                  RichText(
                                      text: TextSpan(
                                          text: 'Welcome to ',
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: 'Montserrat',
                                          ),
                                          children: <TextSpan>[
                                        TextSpan(
                                            text: 'Fare Share',
                                            style: TextStyle(
                                              fontSize: 30.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontFamily: 'Montserrat',
                                            ))
                                      ])),
                                  SizedBox(height: 15),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Divider(
                                    height: 0.1,
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 25.0,
                                          bottom: 15.0,
                                        ),
                                        child: Text(
                                          "User",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 20,
                                      // ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.09,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.90,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              )),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      Icon(Icons.email_rounded),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Email ",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!.docs[index]
                                                          ['UEmail'],
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.09,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.90,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                      Icons.account_circle),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "User Name ",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!.docs[index]
                                                          ['uname'],
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Montserrat',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          );
                        } else
                          return SizedBox();
                      });
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    var stringValue = prefs.getString('useremail');
    setState(() {
      eml = stringValue;
    });
    // return stringValue;
  }
}
