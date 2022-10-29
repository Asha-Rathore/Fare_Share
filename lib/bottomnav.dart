import 'package:flutter/material.dart';
import 'home.dart';
import 'notification.dart';
import 'support.dart';
import 'profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({ Key? key }) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var _pagesData = [HomePage(), NotifPage(), SupPage(), ProPage()];
  int _selectedItem = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pagesData[_selectedItem],

        bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // canvasColor: Color(0xFF21BFBD),
          // canvasColor: Color(0xFF5c8ad6),
          canvasColor: Colors.grey[800],
          primaryColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(
              color: Colors.black
            )
          )
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_rounded),
              label: "About Us"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.support_rounded),
              label: "Support"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Profile"
            ),
          ],
          currentIndex: _selectedItem,
          onTap: (setValue) {
            setState(() {
              _selectedItem = setValue;
            });
          },
        ),
      ),
    );
  }
}