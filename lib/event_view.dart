import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class EventListing {
  String key;
  String eventTime;
  String eventSchool;
  String eventPerson;

  EventListing(this.eventTime, this.eventPerson, this.eventSchool);

  EventListing.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        eventTime = snapshot.value["time"].toString(),
        eventPerson = snapshot.value["name"].toString(),
        eventSchool = snapshot.value["school"].toString();
}

class _EventPageState extends State<EventPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  List<EventListing> eventList = new List();

  String categoryShort = "";
  String categoryTitle = "";
  String categoryBody = "";
  String eventLocation = "";

  String backdrop = "Nothing to see here!\nCheck back later for event time listings.";

  _EventPageState() {
    databaseRef.child("events").child(selectedCategory).child(selectedEvent).once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      categoryTitle = snapshot.key;
      var categoryInfo = snapshot.value;
      setState(() {
        categoryShort = categoryInfo["short"];
        categoryBody = categoryInfo["body"];
      });
      databaseRef.child("events").child(selectedCategory).child(selectedEvent).child(selectedYear).once().then((DataSnapshot snapshot) {
        print(snapshot.value);
        if (selectedYear == "Please select a conference") {
          setState(() {
            eventLocation = "";
            backdrop = "Nothing to see here!\nCheck back later for event time listings.";
          });
        }
        else if (snapshot.value != null) {
          setState(() {
            eventLocation = snapshot.value["location"];
            backdrop = "";
          });
        }
        else {
          setState(() {
            eventLocation = "ERROR RETRIEVING EVENT DATA";
            backdrop = "Nothing to see here!\nCheck back later for event time listings.";
          });
        }
      });
    });
    databaseRef.child("events").child(selectedCategory).child(selectedEvent).child(selectedYear).child("events").onChildAdded.listen(onEventAdded);
  }

  onEventAdded(Event event) {
    setState(() {
      eventList.add(new EventListing.fromSnapshot(event.snapshot));
    });
  }

  Icon addCheckmark(String title) {
    if (title == selectedYear) {
      return Icon(Icons.check, color: Colors.blue);
    }
    else {
      return null;
    }
  }

  Widget addEventSelection(String title) {
    return new ListTile(
      trailing: addCheckmark(title),
      title: new Text(title),
      onTap: () {
        setState(() {
          eventList.clear();
          selectedYear = title;
          databaseRef.child("events").child(selectedCategory).child(selectedEvent).child(selectedYear).once().then((DataSnapshot snapshot) {
            print(snapshot.value);
            if (selectedYear == "none") {
              setState(() {
                eventLocation = "Please select a conference first";
                backdrop = "Nothing to see here!\nCheck back later for event time listings.";
              });
            }
            else if (snapshot.value != null) {
              setState(() {
                eventLocation = snapshot.value["location"];
                backdrop = "";
              });
            }
            else {
              setState(() {
                eventLocation = "ERROR RETRIEVING EVENT DATA";
                backdrop = "Nothing to see here!\nCheck back later for event time listings.";
              });
            }
          });
          databaseRef.child("events").child(selectedCategory).child(selectedEvent).child(selectedYear).child("events").onChildAdded.listen(onEventAdded);
        });
        Navigator.pop(context);
      },
    );
  }

  void selectYearDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Select a Conference"),
          content: new Container(
            height: 150.0,
            child: new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  addEventSelection("2019 SVDC"),
                  new Divider(color: Colors.blue, height: 0.0),
                  addEventSelection("2019 SCDC"),
                ],
              )
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: new Text(categoryShort),
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold
            )
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Image.asset('images/filter.png', color: Colors.white, height: 25.0,),
            color: Colors.white,
            onPressed: () {
              selectYearDialog();
            },
          ),
        ],
      ),
      body: new Container(
          padding: EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                categoryTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.left,
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Text(
                ("$eventLocation - $selectedYear"),
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                  fontSize: 17.0,
                ),
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Text(
                categoryBody,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 17.0,
                ),
              ),
              new Divider(
                color: Colors.blue,
                height: 20.0,
              ),
              new Text(
                "Event Schedule:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              new Padding(padding: EdgeInsets.all(0.0)),
              new Expanded(
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      height: 50.0,
                      child: new Center(
                        child: new Text(
                          backdrop,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12.0,
                          ),
                        ),
                      )
                    ),
                    new ListView.builder(
                      itemCount: eventList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                          },
                          child: new Card(
                            child: new Container(
                              padding: EdgeInsets.all(16.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Container(
                                      child: new Text(
                                        eventList[index].eventTime,
                                        style: TextStyle(color: Colors.blue, fontSize: 17.0, fontWeight: FontWeight.bold),
                                      )
                                  ),
                                  new Padding(padding: EdgeInsets.all(5.0)),
                                  new Column(
                                    children: <Widget>[
                                      new Container(
                                        width: MediaQuery.of(context).size.width - 185,
                                        child: new Text(
                                          eventList[index].eventPerson,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.normal,
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
                    ),
                  ],
                )
              )
            ],
          ),
      ),
    );
  }
}
