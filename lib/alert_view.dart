import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_info.dart';

class AlertPage extends StatefulWidget {
  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  String alertTitle = "";
  String alertBody = "";
  String alertDate = "";

  void getAlert() {
    databaseRef.child("alerts").child(selectedAlert).once().then((DataSnapshot snapshot) {
      var alertInfo = snapshot.value;
      setState(() {
        alertTitle = alertInfo["title"].toString();
        alertBody = alertInfo["body"].toString();
        alertDate = alertInfo["date"].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAlert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: new Text("Details"),
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: new SingleChildScrollView(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                alertTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.left,
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Text(
                alertDate,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                  color: Colors.blue,
                  fontSize: 15.0,
                ),
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Text(
                alertBody,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
