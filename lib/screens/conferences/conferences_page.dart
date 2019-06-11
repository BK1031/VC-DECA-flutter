import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:vc_deca_flutter/models/conference.dart';

class ConferencesPage extends StatefulWidget {
  @override
  _ConferencesPageState createState() => _ConferencesPageState();
}

class _ConferencesPageState extends State<ConferencesPage> {
  
  final databaseRef = FirebaseDatabase.instance.reference();
  
  List<Conference> conferenceList = new List();
  
  _ConferencesPageState() {
    databaseRef.child("conferences").onChildAdded.listen((Event event) {
      setState(() {
        conferenceList.add(new Conference.fromSnapshot(event.snapshot));
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: new ListView.builder(
        itemCount: conferenceList.length,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
            onTap: () {
              // TODO: Implement onTap callback here
            },
            child: new Padding(
              padding: new EdgeInsets.only(bottom: 4.0),
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: Colors.white,
                elevation: 6.0,
                child: new Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    new ClipRRect(
                      child: new CachedNetworkImage(
                        placeholder: (context, url) => new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => new Icon(Icons.error),
                        imageUrl: conferenceList[index].imageUrl,
                        height: 120.0,
                        width: 1000.0,
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    new Container(
                      height: 120.0,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            conferenceList[index].shortName.split(" ")[1],
                            style: TextStyle(fontFamily: "Product Sans", fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          new Text(
                            conferenceList[index].shortName.split(" ")[0],
                            style: TextStyle(fontFamily: "Product Sans", fontSize: 20.0, color: Colors.white, decoration: TextDecoration.overline),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
