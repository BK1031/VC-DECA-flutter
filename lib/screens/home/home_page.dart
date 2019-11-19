import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:vc_deca_flutter/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/models/announcement.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:vc_deca_flutter/utils/theme.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final databaseRef = FirebaseDatabase.instance.reference();
  List<Announcement> announcementList = new List();

  @override
  void initState() {
    super.initState();
    databaseRef.child("alerts").onChildAdded.listen((Event event) {
      setState(() {
        if (event.snapshot.value["topic"].toString().contains(role.toUpperCase().split(" ").join("_")) || event.snapshot.value["topic"].toString().contains("ALL_DEVICES") || userPerms.contains('ADMIN')) {
          announcementList.add(new Announcement.fromSnapshot(event.snapshot));
        }
      });
    });
    databaseRef.child("alerts").onChildRemoved.listen((Event event) {
      setState(() {
        if (event.snapshot.value["topic"].toString().contains(role.toUpperCase().split(" ").join("_")) || event.snapshot.value["topic"].toString().contains("ALL_DEVICES") || userPerms.contains('ADMIN')) {
          var oldEntry = announcementList.singleWhere((entry) {
            return entry.key == event.snapshot.key;
          });
          announcementList.removeAt(announcementList.indexOf(oldEntry));
        }
      });
    });
  }

  void toMyEvents() {
    showCupertinoDialog(context: context, builder: (BuildContext context) {
      return new CupertinoAlertDialog(
        title: new Text("No Events Selected"),
        content: new Text(
            '\nPlease select your events from the Competitive Events explorer first.'),
        actions: <Widget>[
          new CupertinoDialogAction(
            child: new Text("OK"),
            onPressed: () async {
              router.pop(context);
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Container(
            width: double.infinity,
            height: 100.0,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  flex: 5,
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: currCardColor,
                    elevation: 6.0,
                    child: new InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      onTap: () {
                        toMyEvents();
                      },
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Icon(Icons.event, size: 35.0, color: darkMode ? Colors.grey : Colors.black54),
                          new Text(
                            "My Events",
                            style: TextStyle(fontSize: 13.0, color: currTextColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                new Padding(padding: EdgeInsets.all(4.0)),
                new Expanded(
                  flex: 3,
                  child: new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: currCardColor,
                    elevation: 6.0,
                    child: new InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      onTap: () {
                        router.navigateTo(context, '/home/announcements', transition: TransitionType.native);
                      },
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text(
                            announcementList.length.toString(),
                            style: TextStyle(fontSize: 35.0, color: darkMode ? Colors.grey : Colors.black54),
                          ),
                          new Text(
                            "Announcements",
                            style: TextStyle(fontSize: 13.0, color: currTextColor),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          new Padding(padding: EdgeInsets.all(4.0)),
          new Container(
            width: double.infinity,
            height: 100.0,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  flex: 3,
                  child: new Visibility(
                    visible: (userPerms.contains('NOTIFICATION_SEND') || userPerms.contains('ADMIN')),
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      elevation: 6.0,
                      child: new InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        onTap: () {
                          router.navigateTo(context, '/home/notification-manager', transition: TransitionType.native);
                        },
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Icon(Icons.notifications_active, size: 35.0, color: darkMode ? Colors.grey : Colors.black54,),
                            new Text(
                              "Send Notification",
                              style: TextStyle(fontSize: 13.0, color: currTextColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                new Padding(padding: EdgeInsets.all(4.0)),
                new Expanded(
                  flex: 5,
                  child: new Visibility(
                    visible: (userPerms.contains('ADMIN')),
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      elevation: 6.0,
                      child: new InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        onTap: () {
                          // TODO: Implement role management
                        },
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Icon(Icons.supervised_user_circle, size: 35.0, color: darkMode ? Colors.grey : Colors.black54),
                            new Text(
                              "Manage Users",
                              style: TextStyle(fontSize: 13.0, color: currTextColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}
