import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluro/fluro.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class AlertEntry {
  String key;
  String alertTitle;
  String alertBody;

  AlertEntry(this.alertTitle, this.alertBody);

  AlertEntry.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        alertTitle = snapshot.value["title"].toString(),
        alertBody = snapshot.value["body"].toString();

  toJson() {
    return {
      "title": alertTitle,
      "body": alertBody
    };
  }
}

class _HomePageState extends State<HomePage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  List<AlertEntry> alertList = new List();

  _HomePageState() {
    databaseRef.child("alerts").onChildAdded.listen(onAlertAdded);
    databaseRef.child("alerts").onChildChanged.listen(onAlertEdited);
    databaseRef.child("alerts").onChildRemoved.listen(onAlertRemoved);
  }

  onAlertAdded(Event event) {
    setState(() {
      alertList.add(new AlertEntry.fromSnapshot(event.snapshot));
    });
  }

  onAlertEdited(Event event) {
    var oldValue =
    alertList.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
      alertList[alertList.indexOf(oldValue)] =
      new AlertEntry.fromSnapshot(event.snapshot);
      alertList.sort((we1, we2) => we1.alertBody.compareTo(we2.alertBody));
    });
  }

  onAlertRemoved(Event event) {
    var oldValue =
    alertList.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
      alertList.removeAt(alertList.indexOf(oldValue));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: alertList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              selectedAlert = alertList[index].key;
              print(selectedAlert);
              router.navigateTo(context, '/alert', transition: TransitionType.native);
            },
            child: new Card(
              child: new Container(
                padding: EdgeInsets.all(16.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                        child: new Icon(
                          Icons.notifications_active,
                          color: Colors.blue,
                        )
                    ),
                    new Padding(padding: EdgeInsets.all(5.0)),
                    new Column(
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width - 150,
                          child: new Text(
                            alertList[index].alertTitle,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        new Padding(padding: EdgeInsets.all(5.0)),
                        new Container(
                          width: MediaQuery.of(context).size.width - 150,
                          child: new Text(
                            alertList[index].alertBody,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    new Padding(padding: EdgeInsets.all(5.0)),
                    new Container(
                        child: new Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.blue,
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
