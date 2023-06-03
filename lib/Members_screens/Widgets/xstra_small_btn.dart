import 'package:flutter/material.dart';

class XSmallBtn extends StatelessWidget {
  XSmallBtn({required this.txt, required this.ontap, required this.clr});

  final String txt;
  final Function ontap;
  final Color clr;

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context)
        .size; // screen size of the Phone for responsiveness

    return MaterialButton(
      onPressed: () {
        ontap();
      },
      color: clr,
      height: screesize.height / 19,
      minWidth: screesize.width / 3.50,
      child: Text(
        txt,
        style: TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
