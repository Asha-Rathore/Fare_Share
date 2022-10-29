import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/Screens/future_history_screen.dart';
import 'package:travelapp/Screens/inprogress_history_screen.dart';
import 'package:travelapp/Screens/sharing_inprogress.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/bottomnav.dart';
import 'package:travelapp/profile.dart';
import 'package:travelapp/services/database_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String? useremail;
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUserEmail();
    super.initState();
  }

  getCurrentUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    var stringValue = prefs.getString('useremail');
    setState(() {
      useremail = stringValue;
    });
    // return stringValue;
  }

  @override
  Widget build(BuildContext context) {
    final double btnmargsize = MediaQuery.of(context).size.width * 0.09;
    return Container(
      
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.darken),
          image: AssetImage('$imgpath/carbackground.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.grey[800],
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => BottomNav()));
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: new Text(
              "History",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
            toolbarHeight: 70.0,
            elevation: 5.0,
          ),
          body: Container(
            height: sizeheight(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 30.0),
                Text(
                  'Travel App ',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(height: 50.0),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => InProgressPage(currentUserEmail: useremail,)));
                          }, 

                          child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 17.0, bottom: 17.0, left: 45.0, right: 45.0),
                                  child: Text(
                                    'Daily Rides',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.grey[800]),
                                )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => SharingHistory(currentUserEmail: useremail,)));
                          }, 

                          child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 17.0, bottom: 17.0, left: 45.0, right: 45.0),
                                  child: Text(
                                    'Sharing',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.grey[800]),
                                )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => FutureHistoryPage(
                                      currentUserEmail: useremail,
                                    )));
                          }, 

                          child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 17.0, bottom: 17.0, left: 45.0, right: 45.0),
                                  child: Text(
                                    'Future Rides',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.grey[800]),
                                )
                        ),
                      )
                    ]
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     width: sizeWidth(context),
                //     margin:
                //         EdgeInsets.only(left: btnmargsize, right: btnmargsize),
                //     child: RaisedButton(
                //         padding: EdgeInsets.only(left: 30, right: 30),
                //         onPressed: () {
                //           Navigator.of(context).pushReplacement(
                //               MaterialPageRoute(builder: (_) => InProgressPage(currentUserEmail: useremail,)));
                //         },
                //         child: Text(
                //           'In Progress',
                //           style: TextStyle(
                //             fontSize: 18,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white,
                //             fontFamily: 'Montserrat',
                //           ),
                //         ),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10.0),
                //         ),
                //         color: Colors.grey[800]
                //       ),
                //   ),
                // ),
                // SizedBox(height: 30.0),
                // Expanded(
                //   child: Container(
                //     width: sizeWidth(context),
                //     margin:
                //         EdgeInsets.only(left: btnmargsize, right: btnmargsize),
                //     child: RaisedButton(
                //         padding: EdgeInsets.only(left: 30, right: 30),
                //         onPressed: () {
                //           Navigator.of(context).push(MaterialPageRoute(
                //               builder: (_) => FutureHistoryPage(
                //                     currentUserEmail: useremail,
                //                   )));
                //         },
                //         child: Text(
                //           'Future',
                //           style: TextStyle(
                //             fontSize: 18,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white,
                //             fontFamily: 'Montserrat',
                //           ),
                //         ),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10.0),
                //         ),
                //         color: Colors.grey[800]
                //       ),
                      
                //   ),
                // ),
                // Expanded(child: SizedBox(height: 30.0)),
              ],
            ),
          )
          ),
    );
  }
}
