import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:vc_deca_flutter/models/conference.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:http/http.dart' as http;

class ConferencesPage extends StatefulWidget {
  @override
  _ConferencesPageState createState() => _ConferencesPageState();
}

class _ConferencesPageState extends State<ConferencesPage> {
  
  final databaseRef = FirebaseDatabase.instance.reference();
  
  List<Conference> conferenceList = new List();

  @override
  void initState() {
    super.initState();
    refreshConferences();
  }

  refreshConferences() async {
    conferenceList.clear();
    try {
      await http.get(getDbUrl("conferences")).then((response) {
        Map responseJson = jsonDecode(response.body);
        responseJson.keys.forEach((key) {
          setState(() {
            conferenceList.add(new Conference.fromJson(responseJson[key], key));
          });
        });
      });
      print(conferenceList);
    }
    catch (error) {
      print("Failed to pull conferences! - $error");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          new Visibility(
              visible: (conferenceList.length == 0),
              child: new Text("Nothing to see here!\nCheck back later for conferences.", textAlign: TextAlign.center)
          ),
          new Padding(padding: EdgeInsets.only(bottom: 8.0)),
          new Expanded(
            child: new ListView.builder(
              itemCount: conferenceList.length,
              itemBuilder: (BuildContext context, int index) {
                return new GestureDetector(
                  onTap: () {
                    selectedConference = conferenceList[index];
                    router.navigateTo(context, 'conference/details', transition: TransitionType.native);
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
                              placeholder: (context, url) => new Container(
                                child: new GlowingProgressIndicator(
                                  child: new Image.asset('images/logo_blue_trans.png', height: 75.0,),
                                ),
                              ),
                              errorWidget: (error, context, url) => new Container(
                                height: 120.0,
                                child: new Center(
                                  child: new Image.asset('images/logo_blue_trans.png', color: Colors.red, height: 75.0,),
                                ),
                              ),
                              imageUrl: conferenceList[index].imageUrl,
                              height: 120.0,
                              width: double.infinity,
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
          ),
        ],
      ),
    );
  }
}
