import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

import '../../user_info.dart';

class NewAnnouncementPage extends StatefulWidget {
  @override
  _NewAnnouncementPageState createState() => _NewAnnouncementPageState();
}

class _NewAnnouncementPageState extends State<NewAnnouncementPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  String alertTitle = "";
  String alertBody = "";
  String notifBody = "";

  bool sendNotif = false;

  double notifcationContainerHeight = 0.0;

  final bodyController = new TextEditingController();

  publish(String title, String alert) {
    if (title != "" && alert != "") {
      databaseRef.child("alerts").push().update({
        "title": title,
        "body": alert,
        "date": new DateFormat('MM/dd/yyyy hh:mm aaa').format(new DateTime.now()),
        "author": name
      });
      if (sendNotif) {
        print("Notify");
        databaseRef.child("notifications").push().update({
          "title": title,
          "body": alert,
        });
      }
      router.pop(context);
    }
    else {
      print("Missing Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: mainColor,
        title: new Text("New Announcement"),
      ),
      backgroundColor: currBackgroundColor,
      body: new SafeArea(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16.0),
              child: new Column(
                children: <Widget>[
                  new TextField(
                    decoration: InputDecoration(
                        labelText: "Title"
                    ),
                    autocorrect: true,
                    onChanged: (input) {
                      setState(() {
                        alertTitle = input;
                      });
                    },
                  ),
                  new TextField(
                    decoration: InputDecoration(
                        labelText: "Details"
                    ),
                    maxLines: null,
                    autocorrect: true,
                    onChanged: (input) {
                      setState(() {
                        alertBody = input;
                      });
                    },
                  ),
                  new SwitchListTile.adaptive(
                    activeColor: mainColor,
                    activeTrackColor: mainColor,
                    value: sendNotif,
                    title: new Text("Send Notification", style: TextStyle(fontFamily: "Product Sans"),),
                    onChanged: (bool) {
                      setState(() {
                        sendNotif = !sendNotif;
                        if (sendNotif) {
                          notifcationContainerHeight = 125;
                        }
                        else {
                          notifcationContainerHeight = 0;
                        }
                      });
                      print("Send Notification: $sendNotif");
                    },
                  ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              height: 75.0,
              child: new RaisedButton(
                onPressed: () {
                  publish(alertTitle, alertBody);
                },
                color: mainColor,
                child: new Text("Publish Announcement", style: TextStyle(fontFamily: "Product Sans", color: Colors.white, fontSize: 18.0),),
              ),
              padding: EdgeInsets.all(16.0),
            )
          ],
        ),
      ),
    );
  }
}