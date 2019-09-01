import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:vc_deca_flutter/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  
  final databaseRef = FirebaseDatabase.instance.reference();
  int announcementCount = 0;
  bool _notificationManagerVisible = false;
  bool _roleManagerVisible = false;

  @override
  void initState() {
    super.initState();
    refreshAnnouncementCount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    refreshAnnouncementCount();
  }

  void refreshAnnouncementCount() async {
    announcementCount = 0;
    try {
      await http.get(getDbUrl("alerts")).then((response) {
        var responseJson = jsonDecode(response.body);
        setState(() {
          announcementCount = responseJson.length;
        });
        print("Found $announcementCount Announcements!");
      });
    }
    catch (error) {
      print("Failed to pull announcement count! - $error");
    }
    if (userPerms.contains('NOTIFICATION_SEND') || userPerms.contains('ADMIN')) {
      setState(() {
        _notificationManagerVisible = true;
      });
    }
    if (userPerms.contains('ADMIN')) {
      setState(() {
        _roleManagerVisible = true;
      });
    }
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
                  child: new GestureDetector(
                    onTap: toMyEvents,
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: Colors.white,
                      elevation: 6.0,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Icon(Icons.event, size: 35.0,),
                          new Text(
                            "My Events",
                            style: TextStyle(fontSize: 13.0),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                new Padding(padding: EdgeInsets.all(4.0)),
                new Expanded(
                  flex: 3,
                  child: new GestureDetector(
                    onTap: () {
                      router.navigateTo(context, '/home/announcements', transition: TransitionType.native);
                    },
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: Colors.white,
                      elevation: 6.0,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text(
                            announcementCount.toString(),
                            style: TextStyle(fontSize: 35.0),
                          ),
                          new Text(
                            "Announcements",
                            style: TextStyle(fontSize: 13.0),
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
                    visible: _notificationManagerVisible,
                    child: new GestureDetector(
                      onTap: () {
                        router.navigateTo(context, '/home/notification-manager', transition: TransitionType.native);
                      },
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: Colors.white,
                        elevation: 6.0,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Icon(Icons.notifications_active, size: 35.0,),
                            new Text(
                              "Send Notification",
                              style: TextStyle(fontSize: 13.0),
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
                    visible: _roleManagerVisible,
                    child: new GestureDetector(
                      onTap: () {
                        // TODO
                      },
                      child: new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: Colors.white,
                        elevation: 6.0,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Icon(Icons.supervised_user_circle, size: 35.0,),
                            new Text(
                              "Role Manager",
                              style: TextStyle(fontSize: 13.0),
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
