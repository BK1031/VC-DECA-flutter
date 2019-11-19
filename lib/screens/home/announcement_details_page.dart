import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class AnnouncementDetailsPage extends StatefulWidget {
  @override
  _AnnouncementDetailsPageState createState() => _AnnouncementDetailsPageState();
}

class _AnnouncementDetailsPageState extends State<AnnouncementDetailsPage> {

  bool _canDelete = false;

  Future<void> markRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> copy = prefs.getStringList("viewedAlerts");
    if (!copy.contains(selectedAnnouncement.key)) {
      copy.add(selectedAnnouncement.key);
    }
    prefs.setStringList("viewedAlerts", copy);
  }

  _AnnouncementDetailsPageState() {
    markRead();
    if (userPerms.contains('ALERT_DELETE') || userPerms.contains('ADMIN')) {
      _canDelete = true;
    }
  }

  void handleDelete() async {
    if (Platform.isIOS) {
      showCupertinoDialog(context: context, builder: (BuildContext context) {
        return new CupertinoAlertDialog(
          title: new Text("Delete Announcement"),
          content: new Text('\nAre you sure you want to delete this announcement?'),
          actions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("Cancel"),
              isDestructiveAction: false,
              isDefaultAction: true,
              onPressed: () async {
                router.pop(context);
              },
            ),
            new CupertinoDialogAction(
              child: new Text("Delete"),
              isDestructiveAction: true,
              onPressed: () async {
                FirebaseDatabase.instance.reference().child("alerts").child(selectedAnnouncement.key).set(null);
                router.pop(context);
                router.pop(context);
              },
            ),
          ],
        );
      });
    }
    else if (Platform.isAndroid) {
      showModalBottomSheet(context: context, builder: (BuildContext context) {
        return new SafeArea(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                title: new Text('Are you sure you want to delete this announcement?'),
              ),
              new ListTile(
                leading: new Icon(Icons.check),
                title: new Text('Yes, delete it!'),
                onTap: () async {
                },
              ),
              new ListTile(
                leading: new Icon(Icons.clear),
                title: new Text('Cancel'),
                onTap: () {
                  router.pop(context);
                },
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("Details"),
      ),
      backgroundColor: currBackgroundColor,
      floatingActionButton: new Visibility(
        visible: _canDelete,
        child: new FloatingActionButton(
          onPressed: () {
            handleDelete();
          },
          child: new Icon(Icons.delete),
          backgroundColor: Colors.red,
        ),
      ),
      body: new Container(
          padding: EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          child: new SingleChildScrollView(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  selectedAnnouncement.title,
                  style: TextStyle(
                    fontFamily: "Product Sans",
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: currTextColor
                  ),
                  textAlign: TextAlign.left,
                ),
                new Padding(padding: EdgeInsets.all(4.0)),
                new Text(
                  "${selectedAnnouncement.date} -- ${selectedAnnouncement.author}",
                  style: TextStyle(
                    fontFamily: "Product Sans",
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    color: mainColor,
                    fontSize: 18.0,
                  ),
                ),
                new Padding(padding: EdgeInsets.all(4.0)),
                new Linkify(
                  style: TextStyle(fontSize: 18.0, color: currTextColor),
                  linkStyle: TextStyle(fontSize: 18.0, color: mainColor),
                  text: selectedAnnouncement.body,
                  onOpen: (url) async {
                    if (await canLaunch(url.url)) {
                      await launch(url.url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                )
              ],
            ),
          )
      ),
    );
  }
}
