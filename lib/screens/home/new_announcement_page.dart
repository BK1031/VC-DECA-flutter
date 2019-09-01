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

  bool sendNotif = true;

  final bodyController = new TextEditingController();

  void confirmPublish() {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return new ConfirmSheet(alertTitle, alertBody, sendNotif);
    });
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
        child: new SingleChildScrollView(
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
                  ],
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                height: 75.0,
                child: new RaisedButton(
                  onPressed: () {
                    confirmPublish();
                  },
                  color: mainColor,
                  child: new Text("Publish Announcement", style: TextStyle(fontFamily: "Product Sans", color: Colors.white, fontSize: 18.0),),
                ),
                padding: EdgeInsets.all(16.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ConfirmSheet extends StatefulWidget {

  String alertTitle = "";
  String alertBody = "";

  bool sendNotif = false;

  ConfirmSheet(this.alertTitle, this.alertBody, this.sendNotif);

  @override
  _ConfirmSheetState createState() => _ConfirmSheetState(this.alertTitle, this.alertBody, this.sendNotif);
}

class _ConfirmSheetState extends State<ConfirmSheet> {

  String alertTitle = "";
  String alertBody = "";

  bool sendNotif = false;

  double visibiltiyBoxHeight = 0.0;

  _ConfirmSheetState(this.alertTitle, this.alertBody, this.sendNotif);

  publish(String title, String alert) {
    if (title != "" && alert != "") {
      FirebaseDatabase.instance.reference().child("alerts").push().update({
        "title": title,
        "body": alert,
        "date": new DateFormat('MM/dd/yyyy hh:mm aaa').format(new DateTime.now()),
        "author": name
      });
      if (sendNotif) {
        print("Notify");
        FirebaseDatabase.instance.reference().child("notifications").push().update({
          "title": "New Announcement",
          "body": title,
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
    return new Container(
      color: currCardColor,
      child: new SafeArea(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
              child: new Text(
                alertTitle,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            new ListTile(
              leading: new Icon(Icons.visibility),
              title: new Text("Visibility"),
              trailing: new Text("All Members"),
              onTap: () {
                setState(() {
                  visibiltiyBoxHeight = 150;
                });
              },
            ),
            new AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: visibiltiyBoxHeight,
              child: new Scrollbar(
                child: new ListView(
                  padding: EdgeInsets.only(right: 16.0, left: 16.0),
                  children: <Widget>[
                    new ListTile(
                      title: new Text("All Members"),
                      trailing: new Icon(Icons.check, color: mainColor,),
                      onTap: () {
                        setState(() {
                          visibiltiyBoxHeight = 0.0;
                        });
                      },
                    ),
                    new ListTile(
                      title: new Text("Advisors"),
                      onTap: () {},
                    ),
                    new ListTile(
                      title: new Text("Officers"),
                      onTap: () {},
                    ),
                    new ListTile(
                      title: new Text("Committee Members"),
                      onTap: () {},
                    ),
                    new ListTile(
                      title: new Text("Cluster Mentors"),
                      onTap: () {},
                    ),
                    new ListTile(
                      title: new Text("Members"),
                      onTap: () {},
                    ),
                  ],
                ),
              )
            ),
            new ListTile(
              leading: sendNotif ? new Icon(Icons.notifications_active) : new Icon(Icons.notifications_off),
              title: new Text("Send Notification"),
              trailing: new Switch.adaptive(
                value: sendNotif,
                activeColor: mainColor,
                onChanged: (value) {
                  setState(() {
                    sendNotif = value;
                  });
                  print("Notify - $sendNotif");
                },
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              height: 75.0,
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: new FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      onPressed: () {
                        router.pop(context);
                      },
                      child: new Text("Cancel", style: TextStyle(fontFamily: "Product Sans", color: mainColor, fontSize: 18.0),),
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(32.0)),
                  new Expanded(
                    child: new RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      onPressed: () {
                        publish(alertTitle, alertBody);
                        router.pop(context);
                      },
                      color: mainColor,
                      child: new Text("Confirm", style: TextStyle(fontFamily: "Product Sans", color: Colors.white, fontSize: 18.0),),
                    ),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
            )
          ],
        ),
      ),
    );
  }
}
