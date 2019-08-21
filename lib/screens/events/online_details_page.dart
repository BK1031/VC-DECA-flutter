import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import '../../user_info.dart';

class OnlineDetailsPage extends StatefulWidget {
  @override
  _OnlineDetailsPageState createState() => _OnlineDetailsPageState();
}

class _OnlineDetailsPageState extends State<OnlineDetailsPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  String participants = "";
  

  _OnlineDetailsPageState() {
    databaseRef.child("events").child(selectedType).child(selectedCluster).child(selectedEvent.eventShort).once().then((DataSnapshot snapshot) {
      participants = snapshot.value["participants"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: eventColor,
        title: new Text(selectedEvent.eventShort),
      ),
      backgroundColor: currBackgroundColor,
      body: new Container(
        child: new SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Hero(
                tag: selectedEvent.eventName,
                child: new Material(
                  color: Colors.transparent,
                  child: new Text(
                    selectedEvent.eventName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)
                  ),
                )
              ),
              new Padding(padding: EdgeInsets.all(4.0),),
              new Card(
                elevation: 6.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: currCardColor,
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Image.asset('images/1to3participants.png'),
                      trailing: new Text(email, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans")),
                    ),
                    new ListTile(
                      title: new Text("Role", style: TextStyle(fontFamily: "Product Sans",)),
                      trailing: new Text(role, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans")),
                    ),
                    new ListTile(
                      title: new Text("Chaperone Group", style: TextStyle(fontFamily: "Product Sans",)),
                      trailing: new Text(chapGroupID, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans")),
                    ),
                    new ListTile(
                      title: new Text("User ID", style: TextStyle(fontFamily: "Product Sans",)),
                      trailing: new Text(userID, style: TextStyle(fontSize: 14.0, fontFamily: "Product Sans")),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
