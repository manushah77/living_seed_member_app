// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:living_seed_member/Members_screens/Login_member/checkLogin.dart';
import 'package:living_seed_member/Members_screens/Models/admindata.dart';
import 'package:living_seed_member/Members_screens/Models/members.dart';
import 'package:living_seed_member/Members_screens/Models/records.dart';
import 'package:living_seed_member/Members_screens/Widgets/small_btn.dart';
import 'package:living_seed_member/Members_screens/categories_member_page.dart';
import 'package:living_seed_member/Members_screens/deposit_member_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;
  List<RecordsData> listData = [];
  AdminData? adminData;
  MemberData? memData;
  XFile? _file;
  String profileImageUrl = '';
  String? paymenturl;

  //pick image
  selectImage(BuildContext parentContext) async {
    final ImagePicker _picker = ImagePicker();
    final _firebaseStorage = FirebaseStorage.instance;
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('upload a photo'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  XFile? file =
                      await _picker.pickImage(source: ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  XFile? file =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

//open url
  Future<void> _launchUrl() async {
    paymenturl = Uri.parse(adminData!.check!).toString();
    final Uri toLaunch = Uri(scheme: 'https', host: paymenturl);

    await launchUrl(toLaunch, mode: LaunchMode.externalApplication);
  }
  //getting today transactions

  Future getTodayTrans() async {
    final currentuser = FirebaseAuth.instance.currentUser;
    if (currentuser != null) {
      QuerySnapshot res = await FirebaseFirestore.instance
          .collection('NewRecord')
          .where('date',
              isGreaterThan: Timestamp.fromDate(
                  DateTime.now().subtract(Duration(days: 91))))
          .where('date',
              isLessThan:
                  Timestamp.fromDate(DateTime.now().add(Duration(days: 1))))
          .where('Parentid', isEqualTo: currentuser.uid)
          .get();

      QuerySnapshot adminsnap =
          await FirebaseFirestore.instance.collection('Admin').get();
      QuerySnapshot memSnap = await FirebaseFirestore.instance
          .collection('Members')
          .where('Added', isEqualTo: currentuser.uid)
          .get();
      if (!mounted) {
        return true;
      }
      setState(() {
        listData = res.docs
            .map((e) => RecordsData.fromMap(e.data() as Map<String, dynamic>))
            .toList();
        listData.sort((a, b) => b.date!.compareTo(a.date!));
        if (adminsnap.docs.isNotEmpty) {
          adminData = AdminData.fromMap(
              adminsnap.docs.first.data() as Map<String, dynamic>);
        }
        if (memSnap.docs.isNotEmpty) {
          memData = MemberData.fromMap(
              memSnap.docs.first.data() as Map<String, dynamic>);
          profileImageUrl = memData!.imageUrl!;
        }
      });
    } else {
      //print('No User');
    }
  }

  double sum = 0;

  MemberData? data;

  @override
  void initState() {
    getTodayTrans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return memData != null
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(21),
              child: AppBar(
                actions: [
                  IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckLogin(),
                          ),
                          (route) => false);
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.black,
                      size: 17,
                    ),
                  ),
                ],
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness:
                      Brightness.dark, // For Android (dark icons)
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            adminData != null ? adminData!.company! : '',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 114, 97, 97)),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Members')
                              .where('Added',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            // <DocumentSnapshot> data=snapshot.data.docs;
                            //final data = snapshot.data!.docs.first;
                            // print(snapshot.data!.docs.first['email']);
                            if (snapshot.hasData) {
                              final myData = snapshot.data;

                              return Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: <Widget>[
                                      Container(
                                        height: screenSize.height / 4.4,
                                        width: screenSize.width / 1.12,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF191414),
                                          borderRadius:
                                              BorderRadius.circular(13.r),
                                        ),
                                      ),
                                      Positioned(
                                          top: 31,
                                          left: 15,
                                          child: myData!.docs[0]
                                                      .get('earning_balance') <
                                                  0
                                              ? Text(
                                                  'You Owe',
                                                  style: TextStyle(
                                                    fontSize: 27.sp,
                                                    fontWeight: FontWeight.w700,
                                                    // color:
                                                    //     Color.fromARGB(255, 205, 106, 110),
                                                    color: Colors.red.shade300,
                                                    shadows: [
                                                      Shadow(
                                                        offset: Offset(4, 4),
                                                        blurRadius: 10.0,
                                                        color: Color.fromARGB(
                                                            50, 0, 0, 0),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Text(
                                                  'You Have',
                                                  style: TextStyle(
                                                    fontSize: 27.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.green,
                                                    shadows: [
                                                      Shadow(
                                                        offset: Offset(4, 4),
                                                        blurRadius: 10.0,
                                                        color: Color.fromARGB(
                                                            50, 0, 0, 0),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                      Positioned(
                                        top: 65,
                                        left: 15,
                                        child: Text(
                                          myData != null
                                              ? '${myData.docs[0].get('earning_balance')} NGN'
                                              : '$sum NGN',
                                          // ? '${data['earning_balance']} NGN'
                                          // : '$sum NGN',
                                          // '${memData!.earmingBalance} NGN'
                                          // : '$sum NGN',
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 120,
                                        left: 15,
                                        child: Image.asset(
                                          'assets/images/stars.png',
                                          scale: 5,
                                        ),
                                      ),
                                      Positioned(
                                        top: 2,
                                        left: 134,
                                        child: Image.asset(
                                          'assets/icons/design2.png',
                                          scale: 5,
                                        ),
                                      ),
                                      Positioned(
                                          top: 140,
                                          left: 30,
                                          child: Row(
                                            children: [
                                              Text(
                                                myData.docs[0].get('fname'),
                                                //  memData!.fname!,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                              SizedBox(width: 3),
                                              Text(
                                                myData.docs[0].get('lname'),
                                                // memData!.lname!,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          )),
                                      Positioned(
                                          top: -39.13,
                                          left: 190,
                                          right: 2,
                                          //bottom: 105.9.h,
                                          child: profileImageUrl.isNotEmpty
                                              ? Container(
                                                  child: CircleAvatar(
                                                      radius: 52,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              profileImageUrl)),
                                                )
                                              : Container(
                                                  child: CircleAvatar(
                                                    radius: 52,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/logo.jpg'),
                                                  ),
                                                )),
                                      Positioned(
                                        top: -46,
                                        left: 190,
                                        right: 4,
                                        child: Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1,
                                                color: Color(0xFFE2E2E2)),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 50,
                                        left: 190,
                                        right: 4,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 20,
                                          child: IconButton(
                                            onPressed: () async {
                                              // selectImage(context);
                                              final ImagePicker _picker =
                                                  ImagePicker();
                                              XFile? file =
                                                  await _picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);

                                              if (file == null) {
                                                return;
                                              } else {
                                                setState(() {
                                                  _file = file;
                                                  //profileImageUrl = _file!.path;
                                                });
                                                if (_file != null) {
                                                  final firebaseStorage =
                                                      FirebaseStorage.instance;
                                                  var snapshot =
                                                      await firebaseStorage
                                                          .ref()
                                                          .child(
                                                              'profileImages/${memData!.added}')
                                                          .putFile(File(
                                                              _file!.path));
                                                  var imgUrl = await snapshot
                                                      .ref
                                                      .getDownloadURL();
                                                  setState(() {
                                                    profileImageUrl = imgUrl;
                                                  });

                                                  final docuser =
                                                      FirebaseFirestore.instance
                                                          .collection('Members')
                                                          .doc(memData!.added);
                                                  docuser.update(
                                                      {'Image': imgUrl});
                                                }
                                              }
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      // Row(children: [
                      //   Text('Payment Link:'),
                      //   TextButton(
                      //       onPressed: () {
                      //         _launchUrl();
                      //       },
                      //       child: Text(adminData!.check!))
                      // ]),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff333D41),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Filter",
                            style: TextStyle(
                                color: Color(0xff2F2F2F),
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Container(
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(1, 1.5),
                              )
                            ]),
                            height: 40,
                            width: 95,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    child: Text(
                                      'From:${"${startDate!.toLocal()}".split(' ')[0]}',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _selectDate('From');
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.calendarAlt,
                                      size: 18,
                                      color: Color(0xFF83050C),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Container(
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(1, 1.5),
                              )
                            ]),
                            height: 40,
                            width: 95,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 70,
                                    child: Text(
                                      'To:${"${endDate!.toLocal()}".split(' ')[0]}',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _selectDate('To');
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.calendarAlt,
                                      size: 18,
                                      color: Color(0xFF83050C),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          MaterialButton(
                            onPressed: () {
                              fetchData();
                            },
                            color: Color(0xFF83050C),
                            height: 42,
                            minWidth: 70,
                            child: Text(
                              'View',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: screenSize.height / 2.90,
                        child: ListView.builder(
                          itemCount: listData.isEmpty ? 0 : listData.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 55,
                                width: 320,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3,
                                      spreadRadius: 2,
                                      offset: Offset(0, 3),
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        if (listData[index].transtype ==
                                            'Credit')
                                          Image.asset(
                                            'assets/icons/Tfee2.png',
                                            scale: 5,
                                          ),
                                        if (listData[index].transtype ==
                                            'Debit')
                                          Image.asset(
                                            'assets/icons/Tfee.png',
                                            scale: 5,
                                          ),
                                        SizedBox(
                                          width: 9,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 14,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '${listData[index].category}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        // fontWeight:
                                                        //     FontWeight.w400,
                                                        color: listData[index]
                                                                    .transtype ==
                                                                'Credit'
                                                            ? Color(0xff18D193)
                                                            : Color(0xFF83050C),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              '${listData[index].transtype} Transaction',
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
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 14,
                                          ),
                                          if (listData[index].transtype ==
                                              'Credit')
                                            Text(
                                              '\₦ ${listData[index].ammount}',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff18D193)),
                                            ),
                                          if (listData[index].transtype ==
                                              'Debit')
                                            Text(
                                              '\₦ ${listData[index].ammount}',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFE83632),
                                              ),
                                            ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            '${DateFormat('dd MMM yyyy').format(listData[index].date!.toDate())}',
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
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
            bottomNavigationBar: Padding(
              padding:
                  EdgeInsets.only(left: 17.5, right: 17.5, top: 10, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SmallBtn(
                      txt: 'CATEGORIES',
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyCategories(
                                    image: profileImageUrl,
                                  )),
                        );
                      },
                      clr: Colors.black),
                  SmallBtn(
                      txt: 'PAY NOW',
                      ontap: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyDeposit(),
                          ),
                        );
                      },
                      clr: Color(0xff83050C))
                ],
              ),
            ),
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  _selectDate(String dateType) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(2099),
    );
    if (picked != null) {
      if (dateType == 'From') {
        setState(() {
          startDate = picked;
        });
      } else if (dateType == 'To') {
        setState(() {
          endDate = picked;
        });
      }
    } else {
      return;
    }
  }

  fetchData() async {
    setState(() {
      listData.clear();
    });
    final currentuser = FirebaseAuth.instance.currentUser;
    if (currentuser != null) {
      QuerySnapshot res = await FirebaseFirestore.instance
          .collection('NewRecord')
          .where('date',
              isGreaterThan:
                  Timestamp.fromDate(startDate!.subtract(Duration(days: 0))))
          .where('date',
              isLessThan: Timestamp.fromDate(endDate!.add(Duration(days: 1))))
          .where('Parentid', isEqualTo: currentuser.uid)
          .get();
      if (res.docs.isNotEmpty) {
        setState(() {
          listData = res.docs
              .map((e) => RecordsData.fromMap(e.data() as Map<String, dynamic>))
              .toList();
          listData.sort((a, b) => b.date!.compareTo(a.date!));
        });
      } else {
        Center(child: Text('There is no Data'));
      }
    }
  }
}
