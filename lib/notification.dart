import 'package:flutter/material.dart';
import 'package:travelapp/Utils/constants.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({ Key? key }) : super(key: key);

  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF21BFBD),
      backgroundColor: Colors.grey[800],
      body: ListView(
        children: [
          Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "About Us",
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
              height: MediaQuery.of(context).size.height - 120.0,
              decoration: BoxDecoration(
                image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.darken),
            image: AssetImage('$imgpath/carbackground.png'),
            fit: BoxFit.cover,
          ),
                //color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 35.0, left: 20.0, right: 20.0),
                      child: Text(
                        "This app is a Final Year Project. Asha and Faiq Ahmed Siddiqui the students of PAF-KIET University lanuched this app with a goal of making travel easy for all. The app is built on Flutter.",
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
                        "They are doing their bacholars in Computer science field from PAF-KIET University. Both are working in the field of Mobile App Development, exploring more about iOS and Android.",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0, /*  */
                        ),
                        textAlign: TextAlign.left,
                      )),
                ],
              ))
        ],
      ),
    );
  }
}
