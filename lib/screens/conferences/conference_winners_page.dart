import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/models/conference_winner.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class ConferenceWinnersPage extends StatefulWidget {
  @override
  _ConferenceWinnersPageState createState() => _ConferenceWinnersPageState();
}

class _ConferenceWinnersPageState extends State<ConferenceWinnersPage> {

  @override
  void initState() {
    super.initState();
    refreshAgenda();
  }

  refreshAgenda() async {
    try {
      await http.get(getDbUrl("conferences/${selectedConference.shortName}/winners")).then((response) {
        winnerList.clear();
        Map responseJson = jsonDecode(response.body);
        responseJson.keys.forEach((key) {
          setState(() {
            winnerList.add(new ConferenceWinner.fromJson(responseJson[key], key));
          });
        });
      });
    }
    catch (error) {
      print("Failed to pull conference winners! - $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Visibility(
            visible: (winnerList.length == 0),
            child: new Text(
              "Nothing to see here!\nCheck back later for conference winners.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mainColor,
              ),
            ),
          ),
          new Expanded(
              child: new ListView.builder(
                itemCount: winnerList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {},
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
                                    winnerList[index].award,
                                    style: TextStyle(color: mainColor, fontSize: 17.0, fontWeight: FontWeight.bold, fontFamily: "Product Sans"),
                                  )
                              ),
                              new Padding(padding: EdgeInsets.all(4.0)),
                              new Expanded(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      child: new Text(
                                        winnerList[index].name,
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
                                      child: new Text(
                                        winnerList[index].event,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
          )
        ],
      ),
    );
  }
}