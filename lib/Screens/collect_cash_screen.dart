import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:travelapp/bottomnav.dart';
import 'package:travelapp/services/database_helper.dart';
import 'package:travelapp/widgets/custome_button.dart';
import 'package:travelapp/widgets/custome_snackbar.dart';

class WalletPage extends StatefulWidget {

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  final box = GetStorage();
  
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
                  "Wallet",
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
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                    child: box.read("key") == null
                    ? Text(
                      "You have Rs.0 in your wallet",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          
                        ),
                        textAlign: TextAlign.left,
                      )
                    : Text(
                      "You have Rs.${box.read("wallet")} in your wallet",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          
                        ),
                        textAlign: TextAlign.left,
                      )
                  ),
              ],
            )
          )
        ],
      ),
      
    );
  }
}