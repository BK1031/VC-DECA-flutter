import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/models/conference_agenda_item.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:vc_deca_flutter/utils/theme.dart';

class ConferenceSchedulePage extends StatefulWidget {
  @override
  _ConferenceSchedulePageState createState() => _ConferenceSchedulePageState();
}

class _ConferenceSchedulePageState extends State<ConferenceSchedulePage> {

  List<ConferenceAgendaItem> agendaList = new List();
  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    databaseRef.child("conferences").child(selectedConference.shortName).child("agenda").onChildAdded.listen((Event event) {
      setState(() {
        agendaList.add(new ConferenceAgendaItem.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Visibility(
            visible: (agendaList.length == 0),
            child: new Text(
              "Nothing to see here!\nCheck back later for conference schedule listings.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mainColor,
              ),
            ),
          ),
          new Expanded(
            child: new ListView.builder(
              itemCount: agendaList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    selectedAgenda = agendaList[index];
                    router.navigateTo(context, '/conference/details/agenda', transition: TransitionType.native);
                  },
                  child: new Container(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      elevation: 6.0,
                      child: new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                                child: new Text(
                                  agendaList[index].time,
                                  style: TextStyle(color: mainColor, fontSize: 17.0, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),
                                )
                            ),
                            new Padding(padding: EdgeInsets.all(4.0)),
                            new Column(
                              children: <Widget>[
                                new Container(
                                  width: MediaQuery.of(context).size.width - 185,
                                  child: new Text(
                                    agendaList[index].title,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: "Product Sans",
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                new Padding(padding: EdgeInsets.all(2.0)),
                                new Container(
                                  width: MediaQuery.of(context).size.width - 185,
                                  child: new Text(
                                    agendaList[index].location,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: "Product Sans",
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            new Container(
                              child: new Icon(
                                Icons.arrow_forward_ios,
                                color: mainColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}