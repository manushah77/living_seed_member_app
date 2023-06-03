import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';

import '../Widgets/large_btn.dart';
import '../home_member_page.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class LogInMember extends StatefulWidget {
  @override
  State<LogInMember> createState() => _LogInMemberState();
}

class _LogInMemberState extends State<LogInMember> {
  final GlobalKey<ScaffoldState> scaffold_key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool isLoading = false;

  TextEditingController emailX = TextEditingController();
  TextEditingController passX = TextEditingController();
  late FirebaseAuth auth;

  @override
  void initState() {
    auth = FirebaseAuth.instance;
    _passwordVisible = false;
    isLoading = false;
    super.initState();
    //Future.delayed(Duration.zero, () => _formKey);
  }

  Future Login() async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: emailX.text, password: passX.text);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color(0xff83050C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          content: const Text(
            "User Log In SuccessFully",
            style: TextStyle(color: Colors.white, fontSize: 19),
          ),
          duration: const Duration(seconds: 1),
        ));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("${e.message}"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close')),
                ],
              ));

      // print(e);
    } finally {
      final tokenupdate = FirebaseFirestore.instance
          .collection('Members')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      String? token = await FirebaseMessaging.instance.getToken();
      await tokenupdate.update({'token': token});
    }
  }

  @override
  void dispose() {
    emailX.dispose();
    passX.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // screen size of the Phone for responsiveness

    _startLoading() {
      setState(() {
        isLoading = true;
      });

      Timer(const Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
        });
      });
    }

    return Scaffold(
        key: scaffold_key, backgroundColor: Colors.white, body: loginWidget());
  }

  Widget loginWidget() {
    var screesize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Container(
        height: screesize.height / 1,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color.fromRGBO(255, 255, 255, 0), Color(0xffFFE7D7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screesize.height / 22,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => const LogIn()));
              //       },
              //       child: const Text(
              //         'Admin',
              //         style: TextStyle(
              //           color: Color(0xff959595),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Living',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                      color: Color(0xff666464),
                    ),
                  ),
                  Text(
                    ' Seed',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                      color: Color(0xff666464),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'MEMBER LOGIN',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 22,
                  color: Color(0xff83050C),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Column(
                children: [
                  Image.asset(
                    'images/dash.png',
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Parent Payment Management Portal',
                    style: TextStyle(
                        color: Color(
                          0xff333D41,
                        ),
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EMAIL',
                        style: TextStyle(
                            color: Color(0xff83050C),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 55,
                        width: 236,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xffDDDCDC),
                              width: 1,
                            )),
                        child: TextFormField(
                          cursorColor: const Color(0xff83050C),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 5),
                              border: InputBorder.none,
                              hintText: 'Enter Email',
                              hintStyle: TextStyle(
                                  color: Color(0xffC4C4C4),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400)),
                          validator: (_) {
                            var email = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                            if (_ == null || _ == '') {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        content: const Text("Enter Your Mail"),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Close'))
                                        ],
                                      ));
                            } else if (email.hasMatch(_)) {
                              return null;
                            } else
                              return "Wrong Email Adress";
                          },
                          controller: emailX,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PASSWORD',
                        style: TextStyle(
                            color: Color(0xff83050C),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 55,
                        width: 236,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xffDDDCDC),
                              //width: 1,
                            )),
                        child: TextFormField(
                          obscureText: !_passwordVisible,
                          cursorColor: const Color(0xff83050C),
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 5, top: 16),
                            border: InputBorder.none,
                            hintText: 'Enter Password',
                            hintStyle: const TextStyle(
                                color: Color(0xffC4C4C4),
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey.withOpacity(0.6),
                              ),
                            ),
                          ),
                          validator: (_) {
                            if (_ == null || _ == '') {
                              return 'Must Enter Password';
                            } else if (_.length < 7) {
                              return 'Password should at least 7 characters';
                            }
                            return null;
                          },
                          controller: passX,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ClipRRect(
                    child: isLoading
                        ? const SizedBox(
                            height: 50,
                            width: 50,
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballPulse,

                              /// Required, The loading type of the widget
                              colors: [Color(0xff83050C)],
                            ),
                          )
                        : Largebtn(
                            txt: 'LOGIN',
                            ontap: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });

                                Login().then(
                                  (value) {
                                    if (value) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage(),
                                        ),
                                      );
                                    }
                                  },
                                );
                              }
                            },
                            clr: const Color(0xff83050C),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
