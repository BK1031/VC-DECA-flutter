import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/models/event_entry.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class EventSelectionPage extends StatefulWidget {
  @override
  _EventSelectionPageState createState() => _EventSelectionPageState();
}

class _EventSelectionPageState extends State<EventSelectionPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  List<EventEntry> eventList = new List();

  _EventSelectionPageState() {
    databaseRef.child("events").child(selectedType).child(selectedCluster).onChildAdded.listen((Event event) {
      setState(() {
        eventList.add(new EventEntry.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(selectedCluster),
        backgroundColor: eventColor,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new Text("Select an event below."),
            new Padding(padding: EdgeInsets.only(bottom: 8.0)),
            new Expanded(
              child: new ListView.builder(
                itemCount: eventList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: new Hero(
                      tag: "${eventList[index].eventName}-card",
                      child: new Card(
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: currCardColor,
                        child: new ListTile(
                          onTap: () {
                            selectedEvent = eventList[index];
                            print(selectedEvent);
                            if (selectedEvent.eventShort == "SMG") {
                              router.navigateTo(context, '/event/cluster/event/smg-details', transition: TransitionType.native);
                            }
                            else if (selectedType == "Roleplay") {
                              router.navigateTo(context, '/event/cluster/event/roleplay-details', transition: TransitionType.native);
                            }
                            else if (selectedType == "Written") {
                              router.navigateTo(context, '/event/cluster/event/written-details', transition: TransitionType.native);
                            }
                            else if (selectedType == "Online") {
                              router.navigateTo(context, '/event/cluster/event/online-details', transition: TransitionType.native);
                            }
                          },
                          leading: new Text(
                            eventList[index].eventShort,
                            style: TextStyle(color: eventColor, fontSize: 17.0, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),
                          ),
                          title: new Text(
                              eventList[index].eventName,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontFamily: "Product Sans", fontSize: 15.0, fontWeight: FontWeight.normal),
                            ),
                          trailing: Icon(Icons.arrow_forward_ios, color: eventColor),
                        ),
                      )
                    )
                  );
                },
              ),
            )
          ],
        )
      ),
    );
  }
}
