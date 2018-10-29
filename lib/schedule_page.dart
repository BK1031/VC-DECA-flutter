import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class EventEntry {
  String key;
  String eventBody;

  EventEntry(this.eventBody);

  EventEntry.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        eventBody = snapshot.value["body"].toString();
}

class _SchedulePageState extends State<SchedulePage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  List<EventEntry> eventList = new List();

  _SchedulePageState() {
    databaseRef.child("events").onChildAdded.listen(onEventAdded);
  }

  onEventAdded(Event event) {
    setState(() {
      eventList.add(new EventEntry.fromSnapshot(event.snapshot));
    });
  }
  
  Widget getLeadingPic(String name) {
    String imagePath = "";
    if (name == "Business Management") {
        imagePath = 'images/business.png';
    }
    else if (name == "Entrepreneurship") {
      imagePath = 'images/entrepreneurship.png';
    }
    else if (name == "Finance") {
      imagePath = 'images/finance.png';
    }
    else if (name == "Hospitality + Tourism") {
      imagePath = 'images/hospitality.png';
    }
    else if (name == "Marketing") {
      imagePath = 'images/marketing.png';
    }
    else if (name == "Personal Financial Literacy") {
      imagePath = 'images/personal-finance.png';
    }
    return Image.asset(
      imagePath,
      height: 35.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Text(
            "Select a category below."
          ),
          new Expanded(
            child: new ListView.builder(
              itemCount: eventList.length,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new ListTile(
                        onTap: () {
                          selectedCategory = eventList[index].key;
                          router.navigateTo(context, '/eventCategory', transition: TransitionType.native);
                        },
                        leading: getLeadingPic(eventList[index].key),
                        title: new Text(
                            eventList[index].key
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue,),
                      ),
                      new Divider(
                        height: 8.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      )
    );
  }
}
