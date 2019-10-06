import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vc_deca_flutter/screens/auth/auth_functions.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class AuthChecker extends StatefulWidget {
  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {

  final databaseRef = FirebaseDatabase.instance.reference();

  Future checkAuth() async {
    var user = await FirebaseAuth.instance.currentUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('darkAppBar')) {
      darkAppBar = prefs.getBool('darkAppBar');
    }
    else {
      await prefs.setBool('darkAppBar', false);
    }
    if (user != null) {
      // User logged
      print("User Logged");
      userID = user.uid;
      await AuthFunctions.getUserData().then((bool retrievedData) async {
        if (retrievedData) {
          print("Retrieved User Data");
          if (darkMode) {
            currTextColor = darkTextColor;
            currBackgroundColor = darkBackgroundColor;
            currCardColor = darkCardColor;
            currDividerColor = darkDividerColor;
          }
          else {
            currTextColor = lightTextColor;
            currBackgroundColor = lightBackgroundColor;
            currCardColor = lightCardColor;
            currDividerColor = lightDividerColor;
          }
          await databaseRef.child("fcmTopics").once().then((DataSnapshot snapshot) {
            Map topicsJson = snapshot.value;
            topicsJson.keys.forEach((key) {
              FirebaseMessaging().unsubscribeFromTopic(key);
            });
          });
          // A nice delay to make sure everything doesn't go to shit
          await Future.delayed(const Duration(milliseconds: 300));
          router.navigateTo(context, '/home', transition: TransitionType.fadeIn, clearStack: true);
        }
        else {
          print("Failed to Retrieve User Data");
          FirebaseAuth.instance.signOut();
          router.navigateTo(context, '/onboarding', transition: TransitionType.fadeIn, clearStack: true);
        }
      });
    }
    else {
      // User not logged
      print("User Not Logged");
      router.navigateTo(context, '/onboarding', transition: TransitionType.fadeIn, clearStack: true);
    }
  }

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: new Center(
        child: new HeartbeatProgressIndicator(
          child: new Image.asset(
            'images/logo_blue_trans.png',
            height: 75.0,
          ),
        ),
      ),
    );
  }
}
