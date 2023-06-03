// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darq/darq.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Models/chatroom.dart';
import 'Models/members.dart';
import 'Models/records.dart';
import 'Widgets/category.dart';
import 'Widgets/small_btn.dart';
import 'chat/ChatRoom.dart';
import 'deposit_member_page.dart';
import 'home_member_page.dart';

class MyCategories extends StatefulWidget {
  String? image;
  MyCategories({this.image});
  @override
  State<MyCategories> createState() => _MyCategoriesState();
}

class _MyCategoriesState extends State<MyCategories> {
  int categeoryLength = 0;

  List<RecordsData> Unique = [];
  MemberData? data;

  num sum = 0;
  final List<Map> myProducts =
      List.generate(5, (index) => {"id": index, "name": ""}).toList();
  // iconImage: 'assets/icons/debit.png',

  String chatRoomId(String user1, String user2) {
    StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Admin')
          // .where('Company', isEqualTo: FirebaseAuth.instance.currentUser!.displayName)
          .snapshots(),
      builder: (context, snapshot) {
        return Container();
      },
    );
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  var adminName;
  getAdminName() {
    FirebaseFirestore.instance
        .collection('Admin')
        .get()
        .then((value) => adminName = value.docs[0]['Account Holder Name']);
  }

  @override
  void initState() {
    super.initState();
    getCatgeory();
    getAdminName();
  }

  @override
  Widget build(BuildContext context) {
    //getCatgeory();
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Members')
                .where('Added',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final mydata = snapshot.data!.docs;

                return Column(
                  children: [
                    Container(
                      width: screenSize.width / 1,
                      height: screenSize.height / 3.5,
                      color: Color(0xFF83050C),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 110,
                            left: 21,
                            child: Text(
                              'Your Payment',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 135,
                            left: 21,
                            child: Text(
                              'CATEGORIES',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 60,
                            left: 205,
                            right: 2,
                            child: Container(
                              width: 113,
                              height: 113,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: widget.image!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(widget.image!))
                                    : DecorationImage(
                                        image: AssetImage(
                                            'assets/images/logo.jpg')),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: screenSize.height / 1.8,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 280,
                                    childAspectRatio: 2 / 2,
                                    crossAxisSpacing: 3,
                                    mainAxisSpacing: 3),
                            itemCount: categeoryLength,
                            itemBuilder: (BuildContext ctx, index) {
                              return CategoryWidget(data: Unique[index]);
                              // return CAtDetail(
                              //     //data: Unique[index],
                              //     );
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: InkWell(
                        onTap: () async {
                          QuerySnapshot snapchatroom = await FirebaseFirestore
                              .instance
                              .collection('chatroom')
                              .where('members', arrayContains: mydata[0].id)
                              .get();
                          if (snapchatroom.docs.isNotEmpty) {
                            ChatroomModel model = ChatroomModel.fromMap(
                                snapchatroom.docs.first.data()
                                    as Map<String, dynamic>);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                        chatRoomId: model.id!,
                                        docId: mydata[0].id,
                                        userId: mydata[0]['Employee_Off'],
                                        // name: '${data[0]['Account Holder Name']}',
                                        // image: '${data[0]['Image']}'
                                        name: '${adminName}',
                                        // compId: mydata[0]['Employee_Off'],
                                        // docid: mydata[0].id,
                                      )),
                            );
                          } else {
                            final newchatRoom = FirebaseFirestore.instance
                                .collection('chatroom')
                                .doc();
                            ChatroomModel model =
                                ChatroomModel(id: newchatRoom.id, members: [
                              mydata[0].id,
                              mydata[0]['Employee_Off'],
                            ]);
                            newchatRoom.set(model.toMap());

                            //next page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                        chatRoomId: newchatRoom.id,
                                        docId: mydata[0].id,
                                        userId: mydata[0]['Employee_Off'],
                                        // name: '${data[0]['Account Holder Name']}',
                                        // image: '${data[0]['Image']}'
                                        name: '${adminName}',
                                        // compId: mydata[0]['Employee_Off'],
                                        // docid: mydata[0].id,
                                      )),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              (Icons.arrow_forward),
                              color: Color(0xff83050C),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'School Messages',
                              style: TextStyle(
                                  color: Color(0xff83050C), fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SmallBtn(
                              txt: 'HOME',
                              ontap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                );
                              },
                              clr: Colors.black),
                          SmallBtn(
                              txt: 'PAY NOW',
                              ontap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyDeposit(),
                                  ),
                                );
                              },
                              clr: Color(0xFF83050C)),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  Widget profilePhoto(String path) => Center(
        child: Stack(
          children: [
            Container(
              height: 140.0,
              width: 140.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                    blurRadius: 5.0,
                    offset: Offset(0.0, 5.0),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                    blurRadius: 5.0,
                    offset: Offset(5.0, 0.0),
                  ),
                ],
                border: Border.all(
                  color: Colors.white,
                  width: 3.0,
                ),
                image: DecorationImage(
                  image: NetworkImage(path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );

  //getting data

  Future getCatgeory() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('NewRecord')
        .where('Parentid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<RecordsData> alldata = snap.docs
        .map((e) => RecordsData.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    setState(() {
      Unique = alldata.distinct((d) => d.category!).toList();
      categeoryLength = Unique.length;
    });
  }

  // Future getCatgeory() async {
  //   for (var item in data!.categories) {
  //     // print("okkkkkkkkkk$item");
  //     QuerySnapshot snap = await FirebaseFirestore.instance
  //         .collection('Categories')
  //         .where('id', isEqualTo: item)
  //         .get();
  //     if (snap.docs.isNotEmpty) {
  //       setState(() {
  //         // print(snap.docs.first['Category']);
  //         myProducts.add(snap.docs.first['Category']);
  //         // unique.add(RecordsData.fromMap(
  //         //     snap.docs.first.data() as Map<String, dynamic>));
  //         //print(unique.first.category);
  //       });
  //     }
  //   }
  // }
}
