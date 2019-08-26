import 'dart:convert';

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


  @override
  void initState() {
    refreshAgenda();
  }

  refreshAgenda() async {
    agendaList.clear();
    try {
      await http.get(getDbUrl("conferences/${selectedConference.shortName}/agenda")).then((response) {
        Map responseJson = jsonDecode(response.body);
        responseJson.keys.forEach((key) {
          setState(() {
            agendaList.add(new ConferenceAgendaItem.fromJson(responseJson[key], key));
          });
        });
      });
      print(agendaList);
    }
    catch (error) {
      print("Failed to pull conference agenda! - $error");
    }
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
                    router.navigateTo(context, '/conferenceScheduleView', transition: TransitionType.native);
                  },
                  child: new Card(
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
                          new Padding(padding: EdgeInsets.all(5.0)),
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
                );
              },
            ),
          )
        ],
      ),
    );
  }
}