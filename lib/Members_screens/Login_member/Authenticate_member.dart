import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_member_page.dart';
import 'login_member_page.dart';


class AuthenticationMember extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return HomePage();
    } else {
      return LogInMember();
    }
  }
}
