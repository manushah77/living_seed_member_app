import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminChatHomeScreen extends StatefulWidget {
  AdminChatHomeScreen(
      {required this.name, required this.compId, required this.docid});
  final String name;
  final String compId;
  final String docid;

  @override
  State<AdminChatHomeScreen> createState() => _AdminChatHomeScreenState();
}

class _AdminChatHomeScreenState extends State<AdminChatHomeScreen>
    with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String chatRoomId(String user1, String user2) {
    StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Admin')
          .where('Company',
              isEqualTo: FirebaseAuth.instance.currentUser!.displayName)
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xFF83050C),
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        ),
        backgroundColor: Color(0xFF83050C),
        title: Text('Chat With Admin'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
              child: Text('User Not found,Tap to Search Again'),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Admin')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data?.docs;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                String roomId = chatRoomId(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    data[0].id);
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (_) => ChatRoom(
                                //       chatRoomId: roomId,
                                //       docId: widget.docid,
                                //       userId: data[0].id,
                                //       name: '${data[0]['Account Holder Name']}',
                                //       image: '${data[0]['Image']}',
                                //       // userMap: userMap!,
                                //     ),
                                //   ),
                                // );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12),
                                child: Container(
                                  height: 90,
                                  width: 330,
                                  decoration: BoxDecoration(
                                      color: Color(0xff83050C),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                            )),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    '${data![0]['Image']}'),
                                                fit: BoxFit.cover),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        data[0]['Account Holder Name'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 85,
                                      ),
                                      Icon(FontAwesomeIcons.message,
                                          color: Colors.white),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Container();
                    }),
              ],
            ),
    );
  }
}
