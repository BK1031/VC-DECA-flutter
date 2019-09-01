import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class NotificationManagerPage extends StatefulWidget {
  @override
  _NotificationManagerPageState createState() => _NotificationManagerPageState();
}

class _NotificationManagerPageState extends State<NotificationManagerPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  String alertTitle = "";
  String alertBody = "";
  List<String> topic = ["","ALL_DEVICES"];

  double visibilityBoxHeight = 0.0;

  final bodyController = new TextEditingController();

  publish(String title, String alert) {
    if (alertBody != "" && alertTitle != "" && topic.length != 0) {
      print("Notification added to queue");
      FirebaseDatabase.instance.reference().child("notifications").push().update({
        "title": "New Announcement",
        "body": title,
        "topic": topic
      });
      router.pop(context);
    }
    else {
      print("Missing info");
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
              new ListTile(
                leading: new Icon(Icons.group_add),
                title: new Text("Select Recipients"),
                onTap: () {
                  setState(() {
                    if (visibilityBoxHeight == 0.0) {
                      visibilityBoxHeight = 200;
                    }
                    else {
                      visibilityBoxHeight = 0.0;
                    }
                  });
                },
              ),
              new AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: visibilityBoxHeight,
                  child: new Scrollbar(
                    child: new ListView(
                      padding: EdgeInsets.only(right: 16.0, left: 16.0),
                      children: <Widget>[
                        new ListTile(
                          title: new Text("All Members"),
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
                          title: new Text("Advisors"),
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
                          title: new Text("Officers"),
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
                          title: new Text("Committee Members"),
                          trailing: getTrailingCheck('COMMITTEE MEMBER'),
                          onTap: () {
                            setState(() {
                              if (!topic.contains('COMMITTEE MEMBER')) {
                                topic.add('COMMITTEE MEMBER');
                                if (topic.contains('ALL_DEVICES')) {
                                  topic.remove('ALL_DEVICES');
                                }
                              }
                              else {
                                topic.remove('COMMITTEE MEMBER');
                              }
                            });
                            print(topic);
                          },
                        ),
                        new ListTile(
                          title: new Text("Cluster Mentors"),
                          trailing: getTrailingCheck('CLUSTER MENTOR'),
                          onTap: () {
                            setState(() {
                              if (!topic.contains('CLUSTER MENTOR')) {
                                topic.add('CLUSTER MENTOR');
                                if (topic.contains('ALL_DEVICES')) {
                                  topic.remove('ALL_DEVICES');
                                }
                              }
                              else {
                                topic.remove('CLUSTER MENTOR');
                              }
                            });
                            print(topic);
                          },
                        ),
                        new ListTile(
                          title: new Text("Members"),
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
              new Container(
                width: MediaQuery.of(context).size.width,
                height: 75.0,
                child: new RaisedButton(
                  onPressed: () {
                    publish(alertTitle, alertBody);
                  },
                  color: mainColor,
                  child: new Text("Send Notification", style: TextStyle(fontFamily: "Product Sans", color: Colors.white, fontSize: 18.0),),
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
