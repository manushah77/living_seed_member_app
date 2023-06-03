import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Models/depositadd.dart';
import '../Models/records.dart';
import '../cat_table.dart';


class CategoryWidget extends StatefulWidget {
  CategoryWidget({required this.data});

  RecordsData? data;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  int categeoryLength = 0;
  List<RecordsData> NewRecordData = [];
  List<DepositAddModel> popUpData = [];

  double amount = 0;
  double deposit = 0;

  //getdata
  Future getData() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('NewRecord')
        .where('Parentid', isEqualTo: widget.data!.parentID)
        .where('Transaction Category', isEqualTo: widget.data!.category).orderBy('date',descending: false)
        .get();
    if (snap.docs.isNotEmpty) {
      NewRecordData = snap.docs
          .map((e) => RecordsData.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      categeoryLength = NewRecordData.length;

      for (var items in NewRecordData) {
        amount += double.parse(items.ammount.toString());
      }
    }
    // QuerySnapshot snap2 = await FirebaseFirestore.instance
    //     .collection('Deposit Add')
    //     .where('Added', isEqualTo: widget.data!.parentID)
    //     .where('Payment Category', isEqualTo: widget.data!.category)
    //     .where('status', isEqualTo: 'approved')
    //     .get();
    // if (snap2.docs.isNotEmpty) {
    //   popUpData = snap2.docs
    //       .map((e) => DepositAddModel.fromMap(e.data() as Map<String, dynamic>))
    //       .toList();

    //   for (var items in popUpData) {
    //     deposit += double.parse(items.ammount.toString());
    //   }
    // }
    setState(() {});
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
            ? InkWell(
                onTap: () {
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => AlertDialog(
                  //     backgroundColor: Color(0xffC4C4C4),
                  //     title: Center(
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Expanded(
                  //             child: Text(
                  //               '${widget.data!.category}',
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.w400,
                  //                 fontSize: 20,
                  //                 color: Color(0xFF83050C),
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             width: 25,
                  //           ),
                  //           IconButton(
                  //             onPressed: () {
                  //               Navigator.pop(context);
                  //             },
                  //             icon: Icon(
                  //               Icons.cancel,
                  //               color: Colors.red,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     content: Builder(
                  //       builder: (context) {
                  //         return Container(
                  //             height: 300,
                  //             width: 315,
                  //             child: ListView.builder(
                  //                 itemCount: categeoryLength,
                  //                 shrinkWrap: true,
                  //                 primary: false,
                  //                 itemBuilder: (context, index) {
                  //                   // return PopUp(data: NewRecordData[index]);
                  //                   return CAtDetail(
                  //                       data: NewRecordData[index]);
                  //                 }));
                  //       },
                  //     ),
                  //   ),
                  // );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CAtDetail(
                                data: NewRecordData,
                              )));
                },
                child: Container(
                    // width: screenSize.width / 2.3,
                    // height: screenSize.height / 8.3,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF83050C),
                              Color(0xFF83050C).withOpacity(0.5),
                            ]),
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/icons/design.png',
                          ),
                        )),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.data!.category}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '\₦ ${amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    )))
            : Container());
  }
}
