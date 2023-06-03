// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetTextField extends StatelessWidget {
  final String hinText;
  final double borderRadius;
  final bool obscureText;
  final double contentPadding;
  final Icon iconButton;

  const GetTextField(
      {super.key,
      required this.hinText,
      required this.borderRadius,
      required this.obscureText,
      required this.contentPadding,
      required this.iconButton});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w300,
        color: Color(0xFF333D41),
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {},
          icon: iconButton,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Color(0xFFDDDCDC), width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Color(0xFFDDDCDC), width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: contentPadding),
        filled: true,
        fillColor: Color(0xFFFEFEFE),
        hintText: hinText,
        hintStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            color: Color(0xFFC4C4C4)),
      ),
    );
  }
}
