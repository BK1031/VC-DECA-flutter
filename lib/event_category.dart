import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';

class EventCategoryPage extends StatefulWidget {
  @override
  _EventCategoryPageState createState() => _EventCategoryPageState();
}

class EventEntry {
  String key;
  String eventBody;
  String eventShort;

  EventEntry(this.eventBody, this.eventShort);

  EventEntry.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        eventBody = snapshot.value["body"].toString(),
        eventShort = snapshot.value["short"].toString();
}

class _EventCategoryPageState extends State<EventCategoryPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  List<EventEntry> eventList = new List();

  _EventCategoryPageState() {
    databaseRef.child("events").child(selectedCategory).onChildAdded.listen(onEventAdded);
  }

  onEventAdded(Event event) {
    setState(() {
      eventList.add(new EventEntry.fromSnapshot(event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: new Text(selectedCategory),
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new Text("Select an event below."),
            new Expanded(
              child: new ListView.builder(
                itemCount: eventList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      selectedEvent = eventList[index].key;
                      print(selectedEvent);
                      router.navigateTo(context, '/event', transition: TransitionType.native);
                    },
                    child: new Card(
                      child: new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                                child: new Text(
                                  eventList[index].eventShort,
                                  style: TextStyle(color: Colors.blue, fontSize: 17.0, fontWeight: FontWeight.bold),
                                )
                            ),
                            new Padding(padding: EdgeInsets.all(5.0)),
                            new Column(
                              children: <Widget>[
                                new Container(
                                  width: MediaQuery.of(context).size.width - 175,
                                  child: new Text(
                                    eventList[index].key,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
//                          new Padding(padding: EdgeInsets.all(5.0)),
//                          new Container(
//                            width: MediaQuery.of(context).size.width - 150,
//                            child: new Text(
//                              eventList[index].eventBody,
//                              textAlign: TextAlign.start,
//                              maxLines: 2,
//                              overflow: TextOverflow.ellipsis,
//                              style: TextStyle(
//                                fontSize: 15.0,
//                              ),
//                            ),
//                          ),
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
              ),
            )
          ],
        )
      ),
    );
  }
}
