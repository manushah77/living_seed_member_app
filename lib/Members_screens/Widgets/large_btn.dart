import 'package:flutter/material.dart';
class Largebtn extends StatelessWidget {
  const Largebtn({required this.txt, required this.ontap, required this.clr});
  final String txt;
  final Function ontap;
  final Color clr;

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context).size; // screen size of the Phone for responsiveness

    return MaterialButton(
      onPressed: () {
        ontap();
      },
      color: clr,
      height: screesize.height / 15,
      minWidth: 300,
      child: Text(
        txt,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13)),
    );
  }
}
