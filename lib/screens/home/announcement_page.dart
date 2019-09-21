import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vc_deca_flutter/main.dart';
import 'package:vc_deca_flutter/models/announcement.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> with RouteAware {

  final databaseRef = FirebaseDatabase.instance.reference();

  bool _visible = false;

  _AnnouncementPageState() {
    if (userPerms.contains("ALERT_CREATE") || userPerms.contains('ADMIN')) {
      _visible = true;
    }
    refreshAnnouncements();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    refreshAnnouncements();
  }
  
  refreshAnnouncements() async {
    try {
      await http.get(getDbUrl("alerts")).then((response) {
        announcementList.clear();
        Map responseJson = jsonDecode(response.body);
        responseJson.keys.forEach((key) {
          setState(() {
            if (responseJson[key]["topic"].toString().contains(role.toUpperCase()) || responseJson[key]["topic"].toString().contains("ALL_DEVICES") || userPerms.contains('ADMIN')) {
              announcementList.add(new Announcement.fromJson(responseJson[key], key));
            }
          });
        });
      });
      print(announcementList);
    }
    catch (error) {
      print("Failed to pull announcements! - $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("Announcements"),
      ),
      backgroundColor: currBackgroundColor,
      floatingActionButton: new Visibility(
        visible: _visible,
        child: new FloatingActionButton(
          child: new Icon(Icons.add),
          backgroundColor: mainColor,
          onPressed: () {
            router.navigateTo(context, '/home/announcements/new', transition: TransitionType.nativeModal);
          },
        ),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new Visibility(
              visible: (announcementList.length == 0),
              child: new Text("Nothing to see here!\nCheck back later for announcements.", textAlign: TextAlign.center)
            ),
            new Padding(padding: EdgeInsets.only(bottom: 8.0)),
            new Expanded(
              child: ListView.builder(
                itemCount: announcementList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        selectedAnnouncement = announcementList[index];
                        print(selectedAnnouncement);
                        router.navigateTo(context, '/home/announcements/details', transition: TransitionType.native);
                      },
                      child: new Column(
                        children: <Widget>[
                          new Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                            color: currCardColor,
                            elevation: 6.0,
                            child: new Container(
                              padding: EdgeInsets.all(16.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Container(
                                      child: new Icon(
                                        Icons.notifications_active,
                                        color: mainColor,
                                      )
                                  ),
                                  new Padding(padding: EdgeInsets.all(4.0)),
                                  new Column(
                                    children: <Widget>[
                                      new Container(
                                        width: MediaQuery.of(context).size.width - 150,
                                        child: new Text(
                                          announcementList[index].title,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: "Product Sans",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      new Padding(padding: EdgeInsets.all(4.0)),
                                      new Container(
                                        width: MediaQuery.of(context).size.width - 150,
                                        child: new Text(
                                          announcementList[index].body,
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: "Product Sans",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Padding(padding: EdgeInsets.all(4.0)),
                                  new Container(
                                      child: new Icon(
                                        Icons.arrow_forward_ios,
                                        color: mainColor,
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new Padding(padding: EdgeInsets.all(4.0))
                        ],
                      )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
