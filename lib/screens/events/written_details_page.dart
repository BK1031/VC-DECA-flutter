import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class WrittenDetailsPage extends StatefulWidget {
  @override
  _WrittenDetailsPageState createState() => _WrittenDetailsPageState();
}

class _WrittenDetailsPageState extends State<WrittenDetailsPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  String participants = "";
  String pages = "";
  String presentationTime = "";
  String guidelinesUrl = "";
  String sampleUrl = "";
  String penaltyUrl = "";

  @override
  void initState() {
    super.initState();
    databaseRef.child("events").child(selectedType).child(selectedCluster)
        .child(selectedEvent.eventShort).once()
        .then((DataSnapshot snapshot) {
      setState(() {
        participants = snapshot.value['participants'].toString();
        pages = snapshot.value['pages'].toString();
        presentationTime = snapshot.value['presentationTime'].toString();
        guidelinesUrl = snapshot.value['guidelines'].toString();
        sampleUrl = snapshot.value['sample'].toString();
        penaltyUrl = snapshot.value['penalty'].toString();
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
                          padding: EdgeInsets.all(16.0),
                          child: new Column(
                            children: <Widget>[
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
                                    new Expanded(
                                      flex: 3,
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Text(
                                            pages,
                                            style: TextStyle(fontSize: 35.0),
                                          ),
                                          new Text(
                                            "Pages",
                                            style: TextStyle(fontSize: 15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                    new Expanded(
                                      flex: 3,
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Text(
                                            presentationTime,
                                            style: TextStyle(fontSize: 35.0),
                                          ),
                                          new Text(
                                            "Minutes",
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
                    ),
                    new Padding(padding: EdgeInsets.all(4.0)),
                    new Card(
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      child: new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              width: double.infinity,
                              height: 100.0,
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex: 3,
                                    child: new GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => new Scaffold(
                                            appBar: AppBar(
                                              backgroundColor: eventColor,
                                              title: new Text("${selectedEvent.eventShort} Guidelines"),
                                            ),
                                            backgroundColor: currBackgroundColor,
                                            body: new WebView(
                                              initialUrl: guidelinesUrl,
                                              javascriptMode: JavascriptMode.unrestricted,
                                            ),
                                          )),
                                        );
                                      },
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Icon(Icons.format_list_bulleted, size: 50.0,),
                                          new Text(
                                            "Guidelines",
                                            style: TextStyle(fontSize: 15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                    flex: 3,
                                    child: new GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => new Scaffold(
                                            appBar: AppBar(
                                              backgroundColor: eventColor,
                                              title: new Text("${selectedEvent.eventShort} Sample Event"),
                                            ),
                                            backgroundColor: currBackgroundColor,
                                            body: new WebView(
                                              initialUrl: sampleUrl,
                                              javascriptMode: JavascriptMode.unrestricted,
                                            ),
                                          )),
                                        );
                                      },
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Icon(Icons.library_books, size: 50.0,),
                                          new Text(
                                            "Sample Event",
                                            style: TextStyle(fontSize: 15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                    flex: 3,
                                    child: new GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => new Scaffold(
                                            appBar: AppBar(
                                              backgroundColor: eventColor,
                                              title: new Text("${selectedEvent.eventShort} Penalty Points"),
                                            ),
                                            backgroundColor: currBackgroundColor,
                                            body: new WebView(
                                              initialUrl: penaltyUrl,
                                              javascriptMode: JavascriptMode.unrestricted,
                                            ),
                                          )),
                                        );
                                      },
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Icon(Icons.close, size: 50.0,),
                                          new Text(
                                            "Penalty Points",
                                            style: TextStyle(fontSize: 15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(4.0)),
                    new Card(
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      child: new Container(
                        width: double.infinity,
                        child: new FlatButton(
                          child: new Text("COMPETITIVE EVENTS SITE"),
                          textColor: eventColor,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => new Scaffold(
                                backgroundColor: currBackgroundColor,
                                body: new WebView(
                                  initialUrl: "https://www.deca.org/high-school-programs/high-school-competitive-events/",
                                  javascriptMode: JavascriptMode.unrestricted,
                                ),
                              )),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}