import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/widgets/custome_button.dart';
import 'package:travelapp/widgets/custome_textfield.dart';

class FinishTripPage extends StatefulWidget {
  String? from;
  String? destination;
  String? totalPrice;
  FinishTripPage(
      {Key? key, this.from = "", this.destination = "", this.totalPrice})
      : super(key: key);

  @override
  State<FinishTripPage> createState() => _FinishTripPageState();
}

class _FinishTripPageState extends State<FinishTripPage> {
  TextEditingController cashController = TextEditingController();
  final box = GetStorage();
  var wallet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.grey[800],
        title: new Text(
          "Finish Trip ",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        toolbarHeight: 70.0,
        elevation: 5.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            addressbox(
              title1: "Gulshan-e-Maymar, Karachi, Pakistan",
              title2: "Up More, Sector 11 I North Karachi Twp, Karachi, Pakistan"
              // title1: widget.from, 
              // title2: widget.destination
            ),
            SizedBox(height: 1.h),
            totalPriceBox(
              "240"
              //widget.totalPrice
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Payment",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            cardBox(context),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "OR",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            //SizedBox(height: 1.h),
            cashBox(context),
            SizedBox(height: 1.h),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomeButton(
                onTap: () {
                  setState(() {
                    wallet = double.parse(widget.totalPrice!) - double.parse(cashController.text);
                    box.write("wallet", wallet);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Payment Collect Successfully.........."),
                    // duration: Duration(seconds: ),
                  ));
                },
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                text: "Collect Cash",
              ),
            ),
            Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.0),
                  child: CustomeButton(
                    text: "Add Review & Rating",
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible:
                            true, // set to false if you want to force a rating
                        builder: (context) => _dialog,
                      );
                    },
                    color: Colors.grey.shade800,
                  ),
                )
          ],
        ),
      ),
    );
    
  }

  final _dialog = RatingDialog(
    initialRating: 1.0,
    // your app's name?
    title: Text(
      'Rating Dialog',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    // encourage your user to leave a high rating?
    // message: Text(
    //   'Tap a star to set your rating. Add more description here if you want.',
    //   textAlign: TextAlign.center,
    //   style: const TextStyle(fontSize: 15),
    // ),
    // your app's logo?
    //image: const FlutterLogo(size: 100),
    submitButtonText: 'Submit',
    commentHint: 'Set your custom comment hint',
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) {
      print('rating: ${response.rating}, comment: ${response.comment}');

      // TODO: add your own logic
      if (response.rating < 3.0) {
        //save firebase
        print(response.rating);
        print(response.comment);
        // send their comments to your email or anywhere you wish
        // ask the user to contact you instead of leaving a bad review
      } else {
        //_rateAndReviewApp();
      }
    },
  );

  Widget totalPriceBox(String? totalprice) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[800],
        ),
        height: 50,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Price",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                "${totalprice} PKR",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addressbox({
    String? title1,
    String? title2,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[800],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.drive_eta_rounded,
                    color: Colors.white,
                    //size: 32,
                  ),
                  Flexible(
                    child: Text(
                      title1!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Colors.white,
                    // size: 32,
                  ),
                  Flexible(
                    child: Text(
                      title2!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 110,
        width: sizeWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[800],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter Debit Card Number",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomeTextFormField(
                hintText: "012 345 8988 2543",
              )
            ],
          ),
        ),
      ),
      
    );
  }

  Widget cashBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 110,
        width: sizeWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[800],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter Amount paid through passenger",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomeTextFormField(
                keyboardType: TextInputType.number,
                controller: cashController,
                hintText: "Cash",
              )
            ],
          ),
        ),
      ),
      
    );
  }
}
