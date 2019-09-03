import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vc_deca_flutter/screens/chat/chat_page.dart';
import 'package:vc_deca_flutter/screens/conferences/conferences_page.dart';
import 'package:vc_deca_flutter/screens/events/events_page.dart';
import 'package:vc_deca_flutter/screens/home/home_page.dart';
import 'package:vc_deca_flutter/screens/settings/settings_page.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final databaseRef = FirebaseDatabase.instance.reference();

  PageController _pageController;
  int _currentTab = 0;
  String _title = "VC DECA";

  void tabTapped(int index) {
    setState(() {
      _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut
      );
    });
  }

  void pageChanged(int index) {
    setState(() {
      _currentTab = index;
      if (_currentTab == 1) {
        _title = "Conferences";
      }
      else if (_currentTab == 2) {
        _title = "Events";
      }
      else if (_currentTab == 3) {
        _title = "Chat";
      }
      else if (_currentTab == 4) {
        _title = "Settings";
      }
      else {
        _title = "VC DECA";
      }
    });
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOS_Permission();
    _firebaseMessaging.getToken().then((token){
      print("FCM Token: " + token);
      databaseRef.child("users").child(userID).update({"fcmToken": token});
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

//   ignore: non_constant_identifier_names
  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseCloudMessagingListeners();
    _pageController = new PageController();
    // Get Session Info
    databaseRef.child("stableVersion").once().then((DataSnapshot snapshot) {
      var stable = snapshot.value;
      print("Current Version: $appVersion");
      print("Stable Version: $stable");
      if (appVersion < stable) {
        print("OUTDATED APP!");
        appStatus = " [OUTDATED]";
      }
      else if (appVersion > stable) {
        print("BETA APP!");
        appStatus = " Beta $appBuild";
      }
      databaseRef.child("users").child(userID).update({
        "appVersion": "$appVersion$appStatus",
        "deviceName": Platform.localHostname,
        "platform": Platform.operatingSystem
      });
    });
    // Get PermsList from Firebase
    databaseRef.child("perms").onChildAdded.listen((Event event) {
      permsList.add(event.snapshot.value);
    });
    // Get PermsList for Current User
    databaseRef.child("users").child(userID).child("perms").onChildAdded.listen((Event event) {
      setState(() {
        userPerms.add(event.snapshot.value);
      });
      // Subscribe to Topics
      FirebaseMessaging().subscribeToTopic("ALL_DEVICES");
      print("Subscribed to ALL_DEVICES");
      FirebaseMessaging().subscribeToTopic(role.toUpperCase());
      print("Subscribed to ${role.toUpperCase()}");
      if (userPerms.contains("CHAT_VIEW")) {
        FirebaseMessaging().subscribeToTopic("GLOBAL_CHAT");
        print("Subscribed to GLOBAL_CHAT");
      }
      if (userPerms.contains("OFFICER_CHAT_VIEW")) {
        FirebaseMessaging().subscribeToTopic("OFFICER_CHAT");
        print("Subscribed to OFFICER_CHAT");
      }
      if (userPerms.contains("LEADER_CHAT_VIEW")) {
        FirebaseMessaging().subscribeToTopic("LEADER_CHAT");
        print("Subscribed to LEADER_CHAT");
      }
      if (userPerms.contains("DEV")) {
        FirebaseMessaging().subscribeToTopic("DEV");
        print("Subscribed to DEV");
      }
      if (chapGroupID != "Not in a Group") {
        FirebaseMessaging().subscribeToTopic(chapGroupID);
      }
      if (mentorGroupID != "Not in a Group") {
        FirebaseMessaging().subscribeToTopic(mentorGroupID);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          _title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0
          ),
        ),
        elevation: 8.0,
      ),
      body: Container(
        color: currBackgroundColor,
        child: new PageView(
          controller: _pageController,
          onPageChanged: pageChanged,
          children: <Widget>[
            new HomePage(),
            new ConferencesPage(),
            new EventsPage(),
            new ChatPage(),
            new SettingsPage()
          ],
        ),
      ),
      bottomNavigationBar: new BottomNavigationBar(
        onTap: tabTapped,
        fixedColor: mainColor,
        currentIndex: _currentTab,
        type: BottomNavigationBarType.fixed,
        iconSize: 25.0,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: new Container(),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: new Container(),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.event),
            title: new Container(),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: new Container(),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: new Container(),
          ),
        ],
      ),
    );
  }
}
