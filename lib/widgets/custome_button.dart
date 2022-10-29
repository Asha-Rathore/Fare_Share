import 'package:flutter/material.dart';
import 'package:travelapp/Utils/constants.dart';

// ignore: must_be_immutable
class CustomeButton extends StatelessWidget {
  String? text;
  FontWeight? fontWeight;
  Color? color;
  Function()? onTap;
  CustomeButton(
      {Key? key,
      this.onTap,
      this.text,
      this.fontWeight = FontWeight.normal,
      this.color = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            text!,
            style: TextStyle(color: Colors.white, fontWeight: fontWeight),
          ),
        )),
      ),
    );
  }
}
