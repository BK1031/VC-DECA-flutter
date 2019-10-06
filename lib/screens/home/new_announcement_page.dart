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
                        labelText: "Title",
                        labelStyle: TextStyle(color: darkMode ? Colors.grey : Colors.black54)
                      ),
                      style: TextStyle(color: currTextColor),
                      autocorrect: true,
                      onChanged: (input) {
                        setState(() {
                          alertTitle = input;
                        });
                      },
                    ),
                    new TextField(
                      decoration: InputDecoration(
                        labelText: "Details",
                        labelStyle: TextStyle(color: darkMode ? Colors.grey : Colors.black54)
                      ),
                      style: TextStyle(color: currTextColor),
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
  List<String> topic = ["","ALL_DEVICES"];

  double visibiltiyBoxHeight = 0.0;

  _ConfirmSheetState(this.alertTitle, this.alertBody, this.sendNotif);

  publish(String title, String alert) {
    if (title != "" && alert != "") {
      FirebaseDatabase.instance.reference().child("alerts").push().update({
        "title": title,
        "body": alert,
        "date": new DateFormat('MM/dd/yyyy hh:mm aaa').format(new DateTime.now()),
        "author": name,
        "topic": topic
      });
      if (sendNotif) {
        print("Notification added to queue");
        FirebaseDatabase.instance.reference().child("notifications").push().update({
          "title": "New Announcement",
          "body": title,
          "topic": topic
        });
      }
      router.pop(context);
    }
    else {
      print("Missing Data");
    }
  }

  Widget getTrailingCheck(String val) {
    Widget returnWidget = Container(child: new Text(""),);
    if (topic.contains(val)) {
      setState(() {
        returnWidget = Icon(Icons.check, color: mainColor);
      });
    }
    return returnWidget;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: currBackgroundColor,
      child: new SafeArea(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
              child: new Text(
                alertTitle,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: currTextColor),
              ),
            ),
            new ListTile(
              leading: new Icon(Icons.visibility, color: darkMode ? Colors.grey : Colors.black54),
              title: new Text("Visibility", style: TextStyle(color: currTextColor)),
              trailing: new Text(
                topic.toString().substring(2, topic.toString().length-1),
                style: TextStyle(color: darkMode ? Colors.grey : Colors.black54)
              ),
              onTap: () {
                setState(() {
                  if (visibiltiyBoxHeight == 0.0) {
                    visibiltiyBoxHeight = 150;
                  }
                  else {
                    visibiltiyBoxHeight = 0.0;
                  }
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
                        title: new Text("All Members", style: TextStyle(color: currTextColor)),
                        trailing: getTrailingCheck('ALL_DEVICES'),
                        onTap: () {
                          setState(() {
                            if (!topic.contains('ALL_DEVICES')) {
                              topic = ["","ALL_DEVICES"];
                            }
                            else {
                              topic.remove('ALL_DEVICES');
                            }
                          });
                          print(topic);
                        },
                      ),
                      new ListTile(
                        title: new Text("Advisors", style: TextStyle(color: currTextColor)),
                        trailing: getTrailingCheck('ADVISOR'),
                        onTap: () {
                          setState(() {
                            if (!topic.contains('ADVISOR')) {
                              topic.add('ADVISOR');
                              if (topic.contains('ALL_DEVICES')) {
                                topic.remove('ALL_DEVICES');
                              }
                            }
                            else {
                              topic.remove('ADVISOR');
                            }
                          });
                          print(topic);
                        },
                      ),
                      new ListTile(
                        title: new Text("Chaperones", style: TextStyle(color: currTextColor)),
                        trailing: getTrailingCheck('CHAPERONE'),
                        onTap: () {
                          setState(() {
                            if (!topic.contains('CHAPERONE')) {
                              topic.add('CHAPERONE');
                              if (topic.contains('ALL_DEVICES')) {
                                topic.remove('ALL_DEVICES');
                              }
                            }
                            else {
                              topic.remove('CHAPERONE');
                            }
                          });
                          print(topic);
                        },
                      ),
                      new ListTile(
                        title: new Text("Officers", style: TextStyle(color: currTextColor),),
                        trailing: getTrailingCheck('OFFICER'),
                        onTap: () {
                          setState(() {
                            if (!topic.contains('OFFICER')) {
                              topic.add('OFFICER');
                              if (topic.contains('ALL_DEVICES')) {
                                topic.remove('ALL_DEVICES');
                              }
                            }
                            else {
                              topic.remove('OFFICER');
                            }
                          });
                          print(topic);
                        },
                      ),
                      new ListTile(
                        title: new Text("Committee Members", style: TextStyle(color: currTextColor)),
                        trailing: getTrailingCheck('COMMITTEE_MEMBER'),
                        onTap: () {
                          setState(() {
                            if (!topic.contains('COMMITTEE_MEMBER')) {
                              topic.add('COMMITTEE_MEMBER');
                              if (topic.contains('ALL_DEVICES')) {
                                topic.remove('ALL_DEVICES');
                              }
                            }
                            else {
                              topic.remove('COMMITTEE_MEMBER');
                            }
                          });
                          print(topic);
                        },
                      ),
                      new ListTile(
                        title: new Text("Cluster Mentors", style: TextStyle(color: currTextColor)),
                        trailing: getTrailingCheck('CLUSTER_MENTOR'),
                        onTap: () {
                          setState(() {
                            if (!topic.contains('CLUSTER_MENTOR')) {
                              topic.add('CLUSTER_MENTOR');
                              if (topic.contains('ALL_DEVICES')) {
                                topic.remove('ALL_DEVICES');
                              }
                            }
                            else {
                              topic.remove('CLUSTER_MENTOR');
                            }
                          });
                          print(topic);
                        },
                      ),
                      new ListTile(
                        title: new Text("Members", style: TextStyle(color: currTextColor)),
                        trailing: getTrailingCheck('MEMBER'),
                        onTap: () {
                          setState(() {
                            if (!topic.contains('MEMBER')) {
                              topic.add('MEMBER');
                              if (topic.contains('ALL_DEVICES')) {
                                topic.remove('ALL_DEVICES');
                              }
                            }
                            else {
                              topic.remove('MEMBER');
                            }
                          });
                          print(topic);
                        },
                      ),
                    ],
                  ),
                )
            ),
            new ListTile(
              leading: sendNotif ? new Icon(Icons.notifications_active, color: darkMode ? Colors.grey : Colors.black54) : new Icon(Icons.notifications_off, color: darkMode ? Colors.grey : Colors.black54),
              title: new Text("Send Notification", style: TextStyle(color: currTextColor)),
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
