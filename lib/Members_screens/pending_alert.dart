import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:living_seed_member/Members_screens/Models/deposit_model.dart';
import 'package:living_seed_member/Members_screens/Models/members.dart';
import 'package:living_seed_member/Members_screens/home_member_page.dart';


class PendingAlertScreen extends StatefulWidget {
  // DepositAlertScreen({required this.compId, required this.name});
  //
  // final String compId;
  // final String name;

  @override
  State<PendingAlertScreen> createState() => _PendingAlertScreenState();
}

class _PendingAlertScreenState extends State<PendingAlertScreen> {
  // double tak = 0.0;
  double v = 0.0;
  double sum = 0.0;
  int id = 0;

  bool value = false;
  bool isLoadnig = false;
  bool descending = false;
  bool viewVisible = true;

  final List<dynamic> values = [];
  MemberData? data;

  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    getMembers();
    Future.delayed(Duration.zero, () => _formKey);
  }

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context)
        .size; // screen size of the Phone for responsiveness

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff83050C),
        title: const Center(
          child: Text(
            ' DEPOSIT ALERT',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            // Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          icon: const Icon(
            Icons.home,
            color: Color(0xffFFFFFF),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: isLoadnig
              ? Container()
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Deposit Add')
                      .where('Added',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .where('status', isEqualTo: 'pending')
                      .orderBy('Deposit Amount', descending: descending)
                      .snapshots(),
                  builder: (context, snapshot) {
                    //String? images;
                    if (snapshot.hasData) {
                      final mydata = snapshot.data!.docs;
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        sum = 0;
                        Deposit deposit = Deposit(checked: false);
                        DepositModel.deposit.add(deposit);

                        for (int j = 0; j < snapshot.data!.docs.length; j++) {
                          String tak = mydata[j]['Deposit Amount'].toString();
                          v = double.parse(tak);
                          // tak = mydata[j]['Deposit Amount'].toDouble;
                          //  print(v);
                          sum += v;
                          // print(sum);
                        }
                      }
                      for (int i = 0; i < snapshot.data!.docs.length; i++)
                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: screesize.height / 5.9,
                              color: const Color(0xff83050C),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 22.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF)
                                              .withOpacity(0.74),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\₦ ${sum}",
                                          style: TextStyle(
                                              color: Color(0xFFFFFFFF),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 30.0, bottom: 6),
                                          child: Image.asset(
                                            'images/tick.png',
                                            height: 60,
                                            width: 60,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 17.0, right: 17),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    "Pending Approval",
                                    style: TextStyle(
                                        color: Color(0xFF333D41),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            descending = true;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.keyboard_arrow_up,
                                          color: Color(0xff83050C),
                                        ),
                                      ),
                                      Text(
                                        "Sort",
                                        style: TextStyle(
                                            color: Color(0xff83050C),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            descending = false;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Color(0xff83050C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screesize.height / 1.83,
                              child: ListView(
                                children: [
                                  for (int i = 0;
                                      i < snapshot.data!.docs.length;
                                      i++)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20, top: 10),
                                      child: Container(
                                        height: screesize.height / 12,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFFFFFF),
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: InkWell(
                                          onTap: () {},
                                          child: ListTile(
                                            leading: Container(
                                                height: 40,
                                                width: 40,
                                                child: data!.imageUrl != ''
                                                    ? CircleAvatar(
                                                        radius: 17,
                                                        backgroundImage:
                                                            NetworkImage(data!
                                                                .imageUrl!),
                                                      )
                                                    : CircleAvatar(
                                                        radius: 17,
                                                        backgroundImage: AssetImage(
                                                            'assets/images/logo.jpg'),
                                                      )),
                                            title: Text(
                                              mydata[i].get('ParentName'),
                                              style: TextStyle(
                                                  color: Color(0xFF2F2F2F),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16),
                                            ),
                                            subtitle: Text(
                                              'Category:${mydata[i].get('Payment Category')}',
                                              style: TextStyle(
                                                  color: Color(0xFF959595),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11),
                                            ),
                                            trailing: FittedBox(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '\₦ ${mydata[i]['Deposit Amount']}',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF17BF5F),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18),
                                                  ),
                                                  SizedBox(
                                                    height: 11,
                                                  ),
                                                  Text(
                                                    '${DateFormat('dd MMM yyyy').format(mydata[i].get('Date').toDate())}',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF959595),
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [],
                            ),
                          ],
                        );
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xff83050C),
                          ),
                          Text(
                            'You Have Nothing',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff83050C),
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
    );
  }

  CheckboxListTile chekbox() {
    return CheckboxListTile(
      activeColor: Color(0xff83050C),
      checkColor: Colors.white,
      value: value,
      onChanged: (newValue) {
        setState(() {
          id++;
          value = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Future getMembers() async {
    setState(() {
      isLoadnig = true;
    });
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Members')
        .where('Added', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        data = MemberData.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>);
        isLoadnig = false;
      });
    }
  }
}
