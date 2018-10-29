import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:fluro/fluro.dart';
import 'user_info.dart';

class AuthChecker extends StatefulWidget {
  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {

  final databaseRef = FirebaseDatabase.instance.reference();

  Future<void> checkUserLogged() async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      //User logged in
      print("User Logged");
      userID = user.uid;

      databaseRef.child("users").child(userID).once().then((DataSnapshot snapshot) {
        var userInfo = snapshot.value;
        email = userInfo["email"];
        role = userInfo["role"];
        name = userInfo["name"];
        chapGroupID = userInfo["group"];
      });
      router.navigateTo(context, '/logged', transition: TransitionType.fadeIn, replace: true);
    }
    else {
      //User log required
      print("User Not Logged");
      router.navigateTo(context, '/notLogged', transition: TransitionType.fadeIn, replace: true);
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
