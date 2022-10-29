import 'package:flutter/material.dart';
import 'package:travelapp/Utils/constants.dart';

// ignore: must_be_immutable
class CustomeTextFormField extends StatefulWidget {
  String? hintText;
  bool obscureText;
  double horizontalMergin;
  int maxLines;
  TextInputType? keyboardType;
  final TextEditingController? controller;
  Widget? suffixIcon;
  String? Function(String?)? validator;
  CustomeTextFormField({
    Key? key,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.suffixIcon,
    this.horizontalMergin = 0.06,
    this.obscureText = false,
    this.controller,
  }) : super(key: key);

  @override
  State<CustomeTextFormField> createState() => _CustomeTextFormFieldState();
}

class _CustomeTextFormFieldState extends State<CustomeTextFormField> {
  late bool _pwShow;
  @override
  void initState() {
    _pwShow = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: sizeWidth(context) * widget.horizontalMergin),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        obscureText: _pwShow,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          filled: false,
          isCollapsed: true,
          // fillColor: whiteColor,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: greyColor),
          contentPadding: const EdgeInsets.fromLTRB(14, 14.0, 14.0, 14.0),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.white, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:
                  const BorderSide(color: Colors.redAccent, width: 1.5)),
          // focusedErrorBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(10.0),
          //     borderSide: const BorderSide(color: errorColor, width: 1.5)),
          // errorBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(10.0),
          //     borderSide: const BorderSide(color: errorColor, width: 1.5)),
          suffixIcon: widget.suffixIcon ??
              Visibility(
                visible: widget.obscureText,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _pwShow = !_pwShow;
                    });
                  },
                  child: _pwShow
                      ? const Icon(
                          Icons.visibility_off,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.visibility,
                          color: Colors.grey[700],
                        ),
                ),
              ),
        ),
      ),
    );
  }
}
