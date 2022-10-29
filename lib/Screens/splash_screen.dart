import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/Screens/driver_profile_screen.dart';
import 'package:travelapp/Screens/login_user_screen.dart';
import 'package:travelapp/Screens/main_screen.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/bottomnav.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(milliseconds: 1200), () {
      navigateUser();
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //     builder: (BuildContext context) => Start()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   //colorFilter: ColorFilter.mode(Colors.black),
        //   image: AssetImage('$imgpath/spsc.png'),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Scaffold(
        //backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: sizeheight(context) * 0.3),
                  Container(
                    //color: Colors.amber,
                    //height: 150,
                    width: sizeWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          '$imgpath/app_logo.png',
                          width: 300
                        )
                        // Text(
                        //   "TravelApp",
                        //   style: TextStyle(
                        //       fontSize: 38,
                        //       fontWeight: FontWeight.bold,
                        //       fontStyle: FontStyle.italic,
                        //       color: Colors.teal),
                        // ),
                        // Container(
                        //     height: 40,
                        //     width: 40,
                        //     child: SvgPicture.asset(
                        //       "$imgpath/Setting.svg",
                        //       color: primaryColor,
                        //       height: 40,
                        //       width: 40,
                        //       cacheColorFilter: true,
                        //     )),
                      ],
                    ),
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //     image: AssetImage('$imgpath/Logoblack.png'),
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    var statusmech = prefs.getBool('misLoggedIn') ?? false;

    if (status) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => BottomNav()));
    } else if (statusmech) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => DriverProfileScreen()));
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => MainScreen()
          //  BottomNav()
          ,
        ),
      );
      // Navigation.pushReplacement(context, "/Login");
      // Get.to(() => StartScreen());
    }
  }
}
