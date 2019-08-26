import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class RoleplayDetailsPage extends StatefulWidget {
  @override
  _RoleplayDetailsPageState createState() => _RoleplayDetailsPageState();
}

class _RoleplayDetailsPageState extends State<RoleplayDetailsPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  String participants = "";


  _RoleplayDetailsPageState() {
    databaseRef.child("events").child(selectedType).child(selectedCluster).child(selectedEvent.eventShort).once().then((DataSnapshot snapshot) {
      setState(() {
        participants = snapshot.value["participants"].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: eventColor,
          title: new Text(selectedEvent.eventShort),
          elevation: 0.0,
        ),
        backgroundColor: currBackgroundColor,
        body: new Stack(
          children: <Widget>[
            new Container(
              color: eventColor,
              height: 100.0,
            ),
            new Container(
              child: new SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Hero(
                      tag: "${selectedEvent.eventName}-card",
                      child: new Card(
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: currCardColor,
                        child: new Container(
                          padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 16.0),
                          child: new Column(
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.all(4.0),),
                              new Text(
                                  selectedEvent.eventName,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)
                              ),
                              new Container(
                                width: double.infinity,
                                height: 100.0,
                                child: new Row(
                                  children: <Widget>[
                                    new Expanded(
                                      flex: 3,
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Text(
                                            participants,
                                            style: TextStyle(fontSize: 35.0),
                                          ),
                                          new Text(
                                            "Participants",
                                            style: TextStyle(fontSize: 15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new Text(
                                selectedEvent.eventBody,
                                style: TextStyle(fontSize: 15.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}
