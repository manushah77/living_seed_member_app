// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:living_seed_member/Members_screens/pending_alert.dart';

import 'Models/admindata.dart';
import 'Models/cateogryModel.dart';
import 'Models/members.dart';
import 'Widgets/small_btn.dart';
import 'Widgets/xstra_small_btn.dart';
import 'home_member_page.dart';

class MyDeposit extends StatefulWidget {
  const MyDeposit({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDeposit> createState() => _MyDepositState();
}

class _MyDepositState extends State<MyDeposit> {
  TextEditingController amountX = TextEditingController();
  TextEditingController dateX = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // final itemm = ['TRANSPORT', 'UNIFORM', 'TUTION'];
  // String dropdownValuee = 'TRANSPORT';
  String selectedCategory = "";
  AdminData? adminData;
  DateTime Date = DateTime.now();
  Future<String>? mtoken;
  MemberData? memberData;
  List<CategoryModel> catmodel = [];
  XFile? img;
  XFile? _file;

  String? imgUrlNew;

  Future getToken() async {
    QuerySnapshot memsnapshot = await FirebaseFirestore.instance
        .collection('Members')
        .where('Added', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    memberData = MemberData.fromMap(
        memsnapshot.docs.first.data() as Map<String, dynamic>);
    QuerySnapshot snapshotcat = await FirebaseFirestore.instance
        .collection('Categories')
        .where('Added By', isEqualTo: memberData!.employee)
        .get();
    catmodel = snapshotcat.docs
        .map((e) => CategoryModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();

    // catmodel.forEach((element) {
    //   print("fffff ${element.bankname}");
    // });
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Admin').get();
    adminData =
        AdminData.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    setState(() {});
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context).size;
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xFF83050C),
              statusBarIconBrightness:
                  Brightness.light, // For Android (dark icons)
            ),
            centerTitle: true,
            backgroundColor: Color(0xFF83050C),
            elevation: 0,
            title: Text(
              'MAKE DEPOSIT',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 25.sp,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Admin')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final mydata = snapshot.data;
                      return Column(
                        children: [
                          Container(
                            height: screesize.height / 2.3,
                            width: 414,
                            color: Color(0xFF83050C),
                            child: Column(
                              children: [
                                Container(
                                  width: 330,
                                  height: screesize.height / 15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: [
                                          0.1,
                                          0.5
                                        ],
                                        colors: [
                                          Colors.white38.withOpacity(0.3),
                                          Color(0xFF83050C)
                                        ]),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 1),
                                        spreadRadius: 1,
                                        blurRadius: 20,
                                        color: Colors.black38,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          CupertinoIcons.minus_circle_fill,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Pay into the bank before filling the form below',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bank Details',
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 230,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: catmodel.isEmpty
                                          ? 0
                                          : catmodel.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                          color: Color(0xFFAC6F6F),
                                          child: ListTile(
                                            leading: Image.asset(
                                              'assets/icons/bank.png',
                                              scale: 5,
                                            ),
                                            title: Text(
                                              '${catmodel[index].categoryName}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            trailing: Container(
                                              height: 40,
                                              width: 80,
                                              color: Color(0xFF83050C),
                                              child: TextButton(
                                                child: Text(
                                                  'View',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  if (catmodel[index]
                                                          .bankname !=
                                                      null)
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        backgroundColor:
                                                            Color(0xffC4C4C4),
                                                        title: Container(
                                                          height: 300,
                                                          width:
                                                              double.infinity,
                                                          child: Center(
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        '${catmodel[index].categoryName}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Color(0xFF83050C),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 25,
                                                                    ),
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Acc Name:',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                      '${catmodel[index].bankaccname}',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Text(
                                                                      'Acc Number:',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                      '${catmodel[index].bankaccnumber}',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Text(
                                                                      'Bank Name:',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                      '${catmodel[index].bankname}',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 18.0, right: 18),
                                //   child: Container(
                                //     height: screesize.height / 13,
                                //     width: screesize.width / 1,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(13.r),
                                //       color: Colors.white30,
                                //     ),
                                //     child: Padding(
                                //       padding: EdgeInsets.symmetric(
                                //           horizontal: 14.h),
                                //       child: Row(
                                //         children: [
                                //           Image.asset(
                                //             'assets/icons/bank.png',
                                //             scale: 5,
                                //           ),
                                //           SizedBox(
                                //             width: 10,
                                //           ),
                                //           Container(
                                //             width: screesize.width / 2.7,
                                //             child: Text(
                                //               'Bank:',
                                //               style: TextStyle(
                                //                 fontSize: 18.sp,
                                //                 fontWeight: FontWeight.w600,
                                //                 color: Colors.white,
                                //               ),
                                //             ),
                                //           ),
                                //           Expanded(
                                //             child: Text(
                                //               '${mydata!.docs[0]['Bank name']}',
                                //               overflow: TextOverflow.fade,
                                //               style: TextStyle(
                                //                 fontSize: 20.sp,
                                //                 fontWeight: FontWeight.w400,
                                //                 color: Colors.white,
                                //               ),
                                //             ),
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 18.0, right: 18),
                                //   child: Container(
                                //     height: screesize.height / 13,
                                //     width: screesize.width / 1,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(13.r),
                                //       color: Colors.white30,
                                //     ),
                                //     child: Padding(
                                //       padding: EdgeInsets.symmetric(
                                //           horizontal: 14.h),
                                //       child: Row(
                                //         children: [
                                //           Image.asset(
                                //             'assets/icons/account.png',
                                //             scale: 5,
                                //           ),
                                //           SizedBox(
                                //             width: 10,
                                //           ),
                                //           Container(
                                //             width: screesize.width / 2.50,
                                //             child: Text(
                                //               'Account No:',
                                //               style: TextStyle(
                                //                 fontSize: 18.sp,
                                //                 fontWeight: FontWeight.w600,
                                //                 color: Colors.white,
                                //               ),
                                //             ),
                                //           ),
                                //           Expanded(
                                //             child: Text(
                                //               '${mydata.docs[0]['Account Number']}',
                                //               overflow: TextOverflow.fade,
                                //               style: TextStyle(
                                //                 fontSize: 20.sp,
                                //                 fontWeight: FontWeight.w400,
                                //                 color: Colors.white,
                                //               ),
                                //             ),
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 17.0, right: 17),
                                //   child: Container(
                                //     height: screesize.height / 13,
                                //     width: screesize.width / 1,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(13.r),
                                //       color: Colors.white30,
                                //     ),
                                //     child: Padding(
                                //       padding: EdgeInsets.symmetric(
                                //           horizontal: 14.h),
                                //       child: Row(
                                //         children: [
                                //           Image.asset(
                                //             'assets/icons/bname.png',
                                //             scale: 5,
                                //           ),
                                //           SizedBox(
                                //             width: 10,
                                //           ),
                                //           Container(
                                //             width: screesize.width / 2.77,
                                //             child: Text(
                                //               'Bank Name:',
                                //               style: TextStyle(
                                //                 fontSize: 18.sp,
                                //                 fontWeight: FontWeight.w600,
                                //                 color: Colors.white,
                                //               ),
                                //             ),
                                //           ),
                                //           Expanded(
                                //             child: Text(
                                //               '${mydata.docs[0]['Account Holder Name']}',
                                //               overflow: TextOverflow.fade,
                                //               style: TextStyle(
                                //                 fontSize: 20.sp,
                                //                 fontWeight: FontWeight.w400,
                                //                 color: Colors.white,
                                //               ),
                                //             ),
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 17.h,
                          ),
                          Text(
                            'Deposit Confirmation',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333D41),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 23.w),
                            child: Row(
                              children: [
                                Text(
                                  'AMOUNT PAID',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF83050C),
                                  ),
                                ),
                                SizedBox(width: 82.w),
                                Text(
                                  'DATE',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF83050C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Container(
                                  height: screesize.height / 16,
                                  width: screesize.width / 2.9,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xffDDDCDC),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            bottom: 5, left: 10),
                                        hintText: 'Enter Amount',
                                        border: InputBorder.none),
                                    keyboardType: TextInputType.number,
                                    controller: amountX,
                                    validator: (_) {
                                      if (_ == null || _ == '') {
                                        return ("Enter Amount");
                                      } else
                                        return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Container(
                                    height: screesize.height / 16,
                                    width: screesize.width / 2,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xffDDDCDC),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat('MMM dd yyyy')
                                                .format(Date),
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                selectDate(context);
                                              });
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.solidCalendarAlt,
                                              color: Color(0xff83050C),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 23.0, right: 23),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PAYMENT CATEGORY',
                                  style: TextStyle(
                                      color: Color(0xff83050C),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                InkWell(
                                  onTap: () {
                                    Category(context);
                                  },
                                  child: Container(
                                    //height: screesize.height / 16,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffDDDCDC),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(22, 12, 0, 10),
                                      child: selectedCategory == ""
                                          ? Row(
                                              children: [
                                                Text(
                                                  "Select Category",
                                                  style: TextStyle(
                                                      // color: Color(0xffC4C4C4),
                                                      color: Colors.black87,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    selectedCategory,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffC4C4C4),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                )
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: screesize.height / 19,
                                      width: screesize.width / 1.8,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xffDDDCDC),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Text(
                                          "Payment Proof (Optional)",
                                          style: TextStyle(
                                              // color: Color(0xffC4C4C4),
                                              color: Colors.black87,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        paymentProve();
                                      },
                                      child: Container(
                                        height: screesize.height / 19,
                                        width: screesize.width / 3.2,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade700,
                                          border: Border.all(
                                            color: const Color(0xffDDDCDC),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Text(
                                            "Browse",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "If paying for two categories, please fill the \n form twice with exact category amount",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                // color: Color(0xFFC4C4C4),
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Members')
                                .where('Added',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final mydataa = snapshot.data!.docs;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SmallBtn(
                                        txt: 'PENDING ALERT',
                                        ontap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PendingAlertScreen()));
                                        },
                                        clr: Colors.black),
                                    SmallBtn(
                                      txt: 'SEND ALERT',
                                      ontap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (selectedCategory.isNotEmpty) {
                                            Map<String, dynamic> dta = {
                                              "Deposit Amount":
                                                  double.parse(amountX.text),
                                              'Date': Timestamp.fromDate(Date),
                                              'Type': 'Credit',
                                              "Payment Category":
                                                  selectedCategory,
                                              'Added': FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              'ParentName': mydataa[0]['fname'],
                                              "Note": 'Done',
                                              "status": 'pending',
                                              'imgUrl': imgUrlNew,
                                            };
                                            await FirebaseFirestore.instance
                                                .collection('history')
                                                .add(dta);
                                            await FirebaseFirestore.instance
                                                .collection('Deposit Add')
                                                .add(dta)
                                                .whenComplete(() => sendPushMessage(
                                                    'Confirmation',
                                                    'You have received ₦ ${amountX.text} From ${mydataa[0]['fname']}'))
                                                .then((value) => showDialog(
                                                    context: context,
                                                    builder: ((context) =>
                                                        AlertDialog(
                                                          title: Text('Alert'),
                                                          content: Text(
                                                              'Successfully Deposit'),
                                                          actions: [
                                                            InkWell(
                                                                onTap: () {
                                                                  amountX
                                                                      .clear();
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              PendingAlertScreen()));
                                                                },
                                                                child:
                                                                    Text('Ok'))
                                                          ],
                                                        ))));
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: ((context) =>
                                                    AlertDialog(
                                                        title: Text('Alert'),
                                                        content: Text(
                                                            'Select Category'),
                                                        actions: [
                                                          CloseButton()
                                                        ])));
                                          }
                                        }
                                      },
                                      clr: Color(0xff83050C),
                                    ),
                                  ],
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xff83050C),
                                ),
                              );
                            },
                          )
                        ],
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      //DateFormat _formator = DateFormat.yMMMMd();
      setState(() {
        Date = picked;
      });
    }
  }

  void Category(context) {
    List<CategoryModel> listCat = [];

    for (var item in memberData!.categories!) {
      for (var j in catmodel) {
        if (item == j.id) {
          listCat.add(j);
        }
      }
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 250,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Select Category',
                    style: const TextStyle(
                        color: const Color(0xff83050C),
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                                itemCount: listCat.isEmpty ? 0 : listCat.length,
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedCategory =
                                            listCat[index].categoryName!;
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: ListTile(
                                      title: Text(
                                        listCat[index].categoryName!,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  );
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  sendPushMessage(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA4ZWefKs:APA91bE7oTibqcqMmdvph5Ca6Hd-pmaCTGxltcLdx1NYHhASgPOvUup7b3AYwu3ufyVipfBPo-NzAgiaKxJiljFAfkxuWR3WtncUsOUkLIsNqWLSVHpaDM3_Plu1VArMEV7x5309sWSv',
        },
        body: jsonEncode(
          {
            'notification': {'body': body, 'title': title, "sound": "default"},
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done'
            },
            "to": adminData!.token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  paymentProve() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xffC4C4C4),
        title: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Payment Prove',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Color(0xFF83050C),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      XSmallBtn(
                          txt: 'Upload',
                          ontap: () async {
                            // pickImage();
                            final ImagePicker _picker = ImagePicker();
                            XFile? file = await _picker.pickImage(
                                source: ImageSource.gallery);

                            if (file == null) {
                              return;
                            } else {
                              setState(() {
                                _file = file;
                                //imgUrlNew = _file!.path;
                              });
                            }
                          },
                          clr: Colors.black),
                      XSmallBtn(
                          txt: 'Save',
                          ontap: () {
                            saveImage()
                                .whenComplete(() => Navigator.pop(context));
                          },
                          clr: Color(0xFF83050C)),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future saveImage() async {
    if (_file != null) {
      final firebaseStorage = FirebaseStorage.instance;
      var snapshot = await firebaseStorage
          .ref()
          .child('Payment_prove/')
          .putFile(File(_file!.path));
      var imgUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imgUrlNew = imgUrl;
      });
    }
  }
}
