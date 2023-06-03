// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTrans extends StatelessWidget {
  final String transIcon;
  final String transTitle;
  final String transSubTitle;
  final String transAmount;
  final String transDate;

  const MyTrans(
      {Key? key,
      required this.transIcon,
      required this.transTitle,
      required this.transSubTitle,
      required this.transAmount,
      required this.transDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 371.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            offset: Offset(0, 10),
            color: Color.fromRGBO(130, 126, 126, 0.5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 14.w,
              ),
              Image.asset(
                transIcon,
                scale: 5,
              ),
              SizedBox(
                width: 9.14.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    transTitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF83050C),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    transSubTitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF959595),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 9.14.w,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 9.h,
                ),
                Text(
                  transAmount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE83632),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  transDate,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF959595),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
