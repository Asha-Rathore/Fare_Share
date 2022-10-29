import 'package:flutter/material.dart';
import 'package:travelapp/Screens/admin_home_page.dart';
import 'package:travelapp/Screens/admin_ride_history.dart';
import 'package:travelapp/Screens/admin_users.dart';
import 'package:travelapp/Screens/event_seat_screen.dart';
import 'package:travelapp/Sharing/findsharedrides.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  _AdminMainPageState createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      //backgroundColor: Color(0xFFC1C8E4),
      body: Container(
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(colors: [
        //   Color(0xFF5c8ad6),
        //   Color(0xFFebe1e6),
        //   Color(0xFF141414)
        // ], begin: Alignment.topRight, end: Alignment.bottomLeft)
        // ),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0),
            ),
            SizedBox(height: 25.0),
            Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Row(
                  children: [
                    Text(
                      "Fare Share",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 40.0),
            Container(
              height: MediaQuery.of(context).size.height - 140.0,
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage("$imgpath/carbackground.png"),
                //   fit: BoxFit.cover,
                //   opacity: 0.6
                // ),
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
              ),
              child: ListView(
                primary: false,
                padding: EdgeInsets.only(left: 25.0, right: 20.0),
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 45.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 200.0,
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //========================= Drivers =================
                                SizedBox(height: 30.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AdminHomePage()
                                                      //  PolyLinePointPage()
                                                      //MapSample(),
                                                      ),
                                                );
                                              },
                                              child: Container(
                                                height: 100.0,
                                                width: 130.0,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[800],
                                                    // gradient: LinearGradient(
                                                    //     colors: [
                                                    //       Color(0xFF8ab0e6),
                                                    //       Color(0xFFebe1e6),
                                                    //     ],
                                                    //     begin: Alignment.topRight,
                                                    //     end:
                                                    //         Alignment.bottomLeft),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0))),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                        "Drivers",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 20.0,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        maxLines: 2,
                                                        softWrap: false,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        //========================= Users =================
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdminUserPage(),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 100.0,
                                                width: 130.0,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[800],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0))),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Text(
                                                        "Users",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        maxLines: 2,
                                                        softWrap: false,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AdminRideHistoryPage()
                                          //  PolyLinePointPage()
                                          //MapSample(),
                                          ),
                                    );
                                  },
                                  child: Container(
                                    height: 100.0,
                                    width: 270.0,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            "Ride History",
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 20.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.fade,
                                            maxLines: 2,
                                            softWrap: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
