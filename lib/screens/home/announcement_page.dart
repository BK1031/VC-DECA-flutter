import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vc_deca_flutter/main.dart';
import 'package:vc_deca_flutter/models/announcement.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> with RouteAware {

  final databaseRef = FirebaseDatabase.instance.reference();
  List<Announcement> announcementList = new List();

  List<String> viewedAlerts = new List();

  Future<void> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      viewedAlerts = prefs.getStringList("viewedAlerts");
    });
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  void didPopNext() {
    debugPrint("didPopNext ${runtimeType}");
    getPrefs();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
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
        visible: (userPerms.contains("ALERT_CREATE") || userPerms.contains('ADMIN')),
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
              child: new Text("Nothing to see here!\nCheck back later for announcements.", textAlign: TextAlign.center, style: TextStyle(color: currTextColor),)
            ),
            new Padding(padding: EdgeInsets.only(bottom: 8.0)),
            new Expanded(
              child: ListView.builder(
                itemCount: announcementList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Column(
                    children: <Widget>[
                      new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: currCardColor,
                        elevation: 6.0,
                        child: new InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          onTap: () {
                            selectedAnnouncement = announcementList[index];
                            print(selectedAnnouncement);
                            router.navigateTo(context, '/home/announcements/details', transition: TransitionType.native);
                          },
                          child: new Container(
                            padding: EdgeInsets.all(16.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                    child: new Icon(
                                      Icons.notifications_active,
                                      color: viewedAlerts.contains(announcementList[index].key) ? (darkMode ? Colors.grey : Colors.black54) : mainColor,
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
                                          color: currTextColor
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
                                            color: currTextColor
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
                      ),
                      new Padding(padding: EdgeInsets.all(4.0))
                    ],
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
