import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyButton extends StatelessWidget {
  final Color color;
  final String buttonText;
  final double borderRadius;

  const MyButton(
      {super.key,
      required this.color,
      required this.buttonText,
      required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          )),
          backgroundColor: MaterialStateProperty.all(color),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14.h)),
          textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ))),
      child: Text(buttonText),
    );
  }
}
