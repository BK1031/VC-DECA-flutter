import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:vc_deca_flutter/utils/theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final databaseRef = FirebaseDatabase.instance.reference();
  int announcementCount = 0;
  bool _notificationManagerVisible = false;

  _HomePageState() {
    refreshAnnouncementCount();
  }
  
  refreshAnnouncementCount() async {
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
      print("Failed to pull the announcement list! - $error");
    }
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
                    color: Colors.white,
                    elevation: 6.0,
                    child: new Container()
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
                  child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: Colors.white,
                      elevation: 6.0,
                      child: new Container()
                  ),
                ),
                new Padding(padding: EdgeInsets.all(4.0)),
                new Expanded(
                  flex: 5,
                  child: new GestureDetector(
                    onTap: () {},
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: Colors.white,
                      elevation: 6.0,
                      child: new Container()
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
