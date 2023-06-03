// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAlert extends StatelessWidget {
  final String iconImage;
  final String iconTitle;
  final String iconCredit;
  final String iconDate;

  const MyAlert(
      {super.key,
      required this.iconImage,
      required this.iconTitle,
      required this.iconCredit,
      required this.iconDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 21.h,
        ),
        Container(
          width: 276.w,
          height: 64.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.5.w),
                child: Row(
                  children: [
                    Image.asset(
                      iconImage,
                      scale: 5,
                    ),
                    SizedBox(
                      width: 15.85.w,
                    ),
                    Text(
                      iconTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF83050C),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      iconCredit,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE83632),
                      ),
                    ),
                    Text(
                      iconDate,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF959595),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
