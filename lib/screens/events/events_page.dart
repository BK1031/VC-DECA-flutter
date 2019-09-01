import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

import '../../user_info.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  List<String> eventList = new List();

  _EventsPageState() {
    databaseRef.child("events").onChildAdded.listen((Event event) {
      setState(() {
        eventList.add(event.snapshot.key);
      });
    });
  }

  Widget getLeadingPic(String name) {
    String imagePath = "";
    if (name == "Online") {
      imagePath = 'images/online.png';
    }
    else if (name == "Roleplay") {
      imagePath = 'images/roleplay.png';
    }
    else if (name == "Written") {
      imagePath = 'images/written.png';
    }
    return Image.asset(
      imagePath,
      height: 200.0,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: currBackgroundColor,
      padding: EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Text("Select an event type below."),
          new Expanded(
            child: new GridView.count(
              crossAxisCount: 2,
              children: List.generate(eventList.length, (int index) {
                return new Container(
                  padding: EdgeInsets.all(8.0),
                  child: new GestureDetector(
                    onTap: () {
                      selectedType = eventList[index];
                      print(selectedType);
                      router.navigateTo(context, '/event/cluster', transition: TransitionType.native);
                    },
                    child: new Card(
                      child: getLeadingPic(eventList[index]),
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                    ),
                  ),
                );
              }),
            )
          )
        ],
      ),
    );
  }
}
