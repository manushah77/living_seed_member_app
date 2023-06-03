import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Models/records.dart';

class TransactionCategoryWidget extends StatefulWidget {
  TransactionCategoryWidget({required this.data, required this.name});

  RecordsData? data;
  final String name;

  @override
  State<TransactionCategoryWidget> createState() =>
      _TransactionCategoryWidgetState();
}

class _TransactionCategoryWidgetState extends State<TransactionCategoryWidget> {
  int categeoryLength = 0;
  List<RecordsData> Unique = [];
  double amount = 0;

  //getdata
  Future getData() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('NewRecord')
        .where('parentName', isEqualTo: widget.data!.parentName)
        .where('Transaction Category', isEqualTo: widget.data!.category)
        .get();
    if (snap.docs.isNotEmpty) {
      List<RecordsData> allData = snap.docs
          .map((e) => RecordsData.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      for (var items in allData) {
        setState(() {
          amount += double.parse(items.ammount.toString());
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20),
        child: widget.data!.category != null
            ? Container(
                height: screenSize.height / 14,
                width: screenSize.width / 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0.3, 2)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.data!.transtype == 'Debit')
                        Text(
                          '${widget.data!.category}',
                          style: TextStyle(
                              color: Color(0xff939393),
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      if (widget.data!.transtype == 'Credit')
                        Text(
                          '${widget.data!.category}',
                          style: TextStyle(
                              color: Color(0xff939393),
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      Row(
                        children: [
                          if (widget.data!.transtype == 'Debit')
                            Text(
                              '\₦ ${amount}',
                              style: TextStyle(
                                  color: Color(0xffE83632),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          if (widget.data!.transtype == 'Credit')
                            Text(
                              '\₦ ${amount}',
                              style: TextStyle(
                                  color: Color(0xff18D193),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          SizedBox(
                            width: 5,
                          ),
                          if (widget.data!.transtype == 'Debit')
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Color(0xffE83632),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          if (widget.data!.transtype == 'Credit')
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Color(0xff18D193),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Container());
  }
}
