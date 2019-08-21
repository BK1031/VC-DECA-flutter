import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vc_deca_flutter/models/announcement.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  List<Announcement> announcementList = new List();

  bool _visible = false;

  _AlertPageState() {
    databaseRef.child("alerts").onChildAdded.listen(onAlertAdded);
    databaseRef.child("alerts").onChildChanged.listen(onAlertEdited);
    databaseRef.child("alerts").onChildRemoved.listen(onAlertRemoved);
    if (userPerms.contains("ALERT_CREATE")) {
      _visible = true;
    }
  }

  onAlertAdded(Event event) {
    setState(() {
      announcementList.add(new Announcement.fromSnapshot(event.snapshot));
    });
  }

  onAlertEdited(Event event) {
    var oldValue =
    announcementList.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
      announcementList[announcementList.indexOf(oldValue)] =
      new Announcement.fromSnapshot(event.snapshot);
      announcementList.sort((we1, we2) => we1.body.compareTo(we2.body));
    });
  }

  onAlertRemoved(Event event) {
    var oldValue =
    announcementList.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
      announcementList.removeAt(announcementList.indexOf(oldValue));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("Announcements"),
      ),
      floatingActionButton: new Visibility(
        visible: _visible,
        child: new FloatingActionButton(
          child: new Icon(Icons.add),
          backgroundColor: mainColor,
          onPressed: () {
            router.navigateTo(context, '/home/announcement/new', transition: TransitionType.nativeModal);
          },
        ),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: ListView.builder(
          itemCount: announcementList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  selectedAlert = announcementList[index].key;
                  print(selectedAlert);
                  router.navigateTo(context, '/home/announcement/view', transition: TransitionType.native);
                },
                child: new Column(
                  children: <Widget>[
                    new Card(
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
                            new Padding(padding: EdgeInsets.all(5.0)),
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
                                new Padding(padding: EdgeInsets.all(5.0)),
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
                            new Padding(padding: EdgeInsets.all(5.0)),
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
                    new Padding(padding: EdgeInsets.all(5.0))
                  ],
                )
            );
          },
        ),
      ),
    );
  }
}
