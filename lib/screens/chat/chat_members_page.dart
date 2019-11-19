import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/models/user.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class ChatMembersPage extends StatefulWidget {
  @override
  _ChatMembersPageState createState() => _ChatMembersPageState();
}

class _ChatMembersPageState extends State<ChatMembersPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  List<User> memberList = new List();

  @override
  void initState() {
    super.initState();
    databaseRef.child("users").onChildAdded.listen((Event event) {
      if (selectedChat == "global") {
        setState(() {
          memberList.add(new User.fromSnapshot(event.snapshot));
        });
      }
      else if (selectedChat == "officer" && event.snapshot.value["role"] == "Officer") {
        setState(() {
          memberList.add(new User.fromSnapshot(event.snapshot));
        });
      }
      else if (selectedChat == "leader" && (event.snapshot.value["role"] == "Officer" || event.snapshot.value["role"] == "Committee Member" || event.snapshot.value["role"] == "Cluster Mentor")) {
        setState(() {
          memberList.add(new User.fromSnapshot(event.snapshot));
        });
      }
      else {
        if (selectedChat == event.snapshot.value["mentorGroup"] || selectedChat == event.snapshot.value["chapGroup"]) {
          setState(() {
            memberList.add(new User.fromSnapshot(event.snapshot));
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Members"),
      ),
      backgroundColor: currBackgroundColor,
      body: Container(
          padding: EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new ListView.builder(
                  itemCount: memberList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: new Card(
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: currCardColor,
                        child: new ListTile(
                          onTap: () {},
                          leading: new ClipOval(
                            child: new CachedNetworkImage(
                              imageUrl: memberList[index].profilePicUrl,
                              width: 45.0,
                              height: 45.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                          title: new Text(
                            memberList[index].name,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontFamily: "Product Sans", fontSize: 15.0, fontWeight: FontWeight.normal),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, color: eventColor),
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
