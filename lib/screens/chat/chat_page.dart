import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  bool _chatVisible = false;
  bool _officerVisible = false;
  bool _budgetVisible = false;
  bool _devVisible = false;

  _ChatPageState() {
    if (userPerms.contains("CHAT_VIEW") || userPerms.contains("ADMIN")) {
      _chatVisible = true;
    }
    if (userPerms.contains("OFFICER_CHAT_VIEW") || userPerms.contains("ADMIN")) {
      _officerVisible = true;
    }
    if (userPerms.contains("LEADER_CHAT_VIEW") || userPerms.contains("ADMIN")) {
      _budgetVisible = true;
    }
    if (userPerms.contains("DEV") || userPerms.contains("ADMIN")) {
      _devVisible = true;
    }
  }

  void toChat(String chatRef) {
    selectedChat = chatRef;
    if (chatRef == "global") {
      chatTitle = "General Chat";
    }
    else if (chatRef == "officer") {
      chatTitle = "Officer Chat";
    }
    else if (chatRef == "leader") {
      chatTitle = "Leader Chat";
    }
    else if (chatRef == "dev") {
      chatTitle = "Dev Env";
    }
    router.navigateTo(context, '/chat/global', transition: TransitionType.native);
  }

  void toMentorChat() {
    String groupCode = "";
    if (mentorGroupID != "Not in a Group") {
      selectedChat = mentorGroupID;
      chatTitle = "Mentor Group";
      router.navigateTo(context, '/chat/global', transition: TransitionType.native);
    }
    else {
      if (Platform.isIOS) {
        showCupertinoDialog(context: context, builder: (context) {
          return CupertinoAlertDialog(
            title: new Text("Join Mentor Group\n"),
            content: new CupertinoTextField(
              autocorrect: false,
              autofocus: true,
              onChanged: (String input) {
                groupCode = input;
              },
              textCapitalization: TextCapitalization.characters,
              placeholder: "Group Code",
            ),
            actions: <Widget>[
              new CupertinoDialogAction(
                child: new Text("Cancel"),
                onPressed: () {
                  router.pop(context);
                },
              ),
              new CupertinoDialogAction(
                child: new Text("Join"),
                onPressed: () {
                  if (groupCode != "") {
                    FirebaseDatabase.instance.reference().child("chat").child(groupCode).once().then((DataSnapshot snapshot) {
                      if (snapshot.value != null) {
                        print("Group exists");
                        setState(() {
                          mentorGroupID = groupCode;
                        });
                        FirebaseDatabase.instance.reference().child("users").child(userID).update({
                          "mentorGroup": mentorGroupID
                        });
                        groupCode = "";
                        Navigator.of(context).pop();
                      }
                      else {
                        print("Failed to find mentor group");
                      }
                    });
                  }
                  else {
                    print("Failed to find mentor group");
                  }
                },
              ),
            ],
          );
        });
      }
      else if (Platform.isAndroid) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Join Mentor Group", style: TextStyle(color: currTextColor),),
                backgroundColor: currBackgroundColor,
                content: new Container(
                  height: 75.0,
                  child: new Column(
                    children: <Widget>[
                      new TextField(
                        onChanged: (String input) {
                          groupCode = input;
                        },
                        textCapitalization: TextCapitalization.characters,
                        autocorrect: false,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: "Group Code",
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("CANCEL"),
                    textColor: mainColor,
                    onPressed: () {
                      router.pop(context);
                    },
                  ),
                  new FlatButton(
                    child: new Text("JOIN"),
                    textColor: mainColor,
                    onPressed: () {
                      if (groupCode != "") {
                        FirebaseDatabase.instance.reference().child("chat").child(groupCode).once().then((DataSnapshot snapshot) {
                          if (snapshot.value != null) {
                            print("Group exists");
                            setState(() {
                              mentorGroupID = groupCode;
                            });
                            FirebaseDatabase.instance.reference().child("users").child(userID).update({
                              "mentorGroup": mentorGroupID
                            });
                            groupCode = "";
                            Navigator.of(context).pop();
                          }
                          else {
                            print("Failed to find mentor group");
                          }
                        });
                      }
                      else {
                        print("Failed to find mentor group");
                      }
                    },
                  )
                ],
              );
            }
        );
      }
    }
  }

  void toChapChat() {
    String groupCode = "";
    if (chapGroupID != "Not in a Group") {
      selectedChat = chapGroupID;
      chatTitle = "Chaperone Group";
      router.navigateTo(context, '/chat/global', transition: TransitionType.native);
    }
    else {
      if (Platform.isIOS) {
        showCupertinoDialog(context: context, builder: (context) {
          return CupertinoAlertDialog(
            title: new Text("Join Chaperone Group\n"),
            content: new CupertinoTextField(
              autocorrect: false,
              autofocus: true,
              onChanged: (String input) {
                groupCode = input;
              },
              textCapitalization: TextCapitalization.characters,
              placeholder: "Group Code",
            ),
            actions: <Widget>[
              new CupertinoDialogAction(
                child: new Text("Cancel"),
                onPressed: () {
                  router.pop(context);
                },
              ),
              new CupertinoDialogAction(
                child: new Text("Join"),
                onPressed: () {
                  if (groupCode != "") {
                    FirebaseDatabase.instance.reference().child("chat").child(groupCode).once().then((DataSnapshot snapshot) {
                      if (snapshot.value != null) {
                        print("Group exists");
                        setState(() {
                          chapGroupID = groupCode;
                        });
                        FirebaseDatabase.instance.reference().child("users").child(userID).update({
                          "chapGroup": chapGroupID
                        });
                        groupCode = "";
                        Navigator.of(context).pop();
                      }
                      else {
                        print("Failed to find chaperone group");
                      }
                    });
                  }
                  else {
                    print("Failed to find chaperone group");
                  }
                },
              ),
            ],
          );
        });
      }
      else if (Platform.isAndroid) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Join Chaperone Group", style: TextStyle(color: currTextColor),),
                backgroundColor: currBackgroundColor,
                content: new Container(
                  height: 75.0,
                  child: new Column(
                    children: <Widget>[
                      new TextField(
                        autocorrect: false,
                        autofocus: true,
                        onChanged: (String input) {
                          groupCode = input;
                        },
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: "Group Code",
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("CANCEL"),
                    textColor: mainColor,
                    onPressed: () {
                      router.pop(context);
                    },
                  ),
                  new FlatButton(
                    child: new Text("JOIN"),
                    textColor: mainColor,
                    onPressed: () {
                      if (groupCode != "") {
                        FirebaseDatabase.instance.reference().child("chat").child(groupCode).once().then((DataSnapshot snapshot) {
                          if (snapshot.value != null) {
                            print("Group exists");
                            setState(() {
                              chapGroupID = groupCode;
                            });
                            FirebaseDatabase.instance.reference().child("users").child(userID).update({
                              "chapGroup": chapGroupID
                            });
                            groupCode = "";
                            Navigator.of(context).pop();
                          }
                          else {
                            print("Failed to find chaperone group");
                          }
                        });
                      }
                      else {
                        print("Failed to find chaperone group");
                      }
                    },
                  )
                ],
              );
            }
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Visibility(
            visible: _chatVisible,
            child: new GestureDetector(
              onTap: () {
                toChat("global");
              },
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: Colors.white,
                elevation: 6.0,
                child: ListTile(
                  title: new Text("General Chat", style: TextStyle(fontSize: 15.0),),
                  trailing: Icon(Icons.arrow_forward_ios, color: mainColor,),
                ),
              ),
            ),
          ),
          new Padding(padding: EdgeInsets.all(4.0)),
          new GestureDetector(
            onTap: () {
              toMentorChat();
            },
            child: new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: Colors.white,
              elevation: 6.0,
              child: ListTile(
                title: new Text("Mentor Group", style: TextStyle(fontSize: 15.0),),
                subtitle: new Text(mentorGroupID),
                trailing: Icon(Icons.arrow_forward_ios, color: mainColor,),
              ),
            ),
          ),
          new Padding(padding: EdgeInsets.all(4.0)),
          new GestureDetector(
            onTap: () {
              toChapChat();
            },
            child: new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: Colors.white,
              elevation: 6.0,
              child: ListTile(
                title: new Text("Chaperone Group", style: TextStyle(fontSize: 15.0),),
                subtitle: new Text(chapGroupID),
                trailing: Icon(Icons.arrow_forward_ios, color: mainColor,),
              ),
            ),
          ),
          new Visibility(visible: _officerVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
          new Visibility(
            visible: _officerVisible,
            child: new GestureDetector(
              onTap: () {
                toChat("officer");
              },
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: Colors.white,
                elevation: 6.0,
                child: ListTile(
                  title: new Text("Officer Chat", style: TextStyle(fontSize: 15.0),),
                  trailing: Icon(Icons.arrow_forward_ios, color: mainColor,),
                ),
              ),
            ),
          ),
          new Visibility(visible: _budgetVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
          new Visibility(
            visible: _budgetVisible,
            child: new GestureDetector(
              onTap: () {
                toChat("leader");
              },
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: Colors.white,
                elevation: 6.0,
                child: ListTile(
                  title: new Text("Leader Chat", style: TextStyle(fontSize: 15.0),),
                  trailing: Icon(Icons.arrow_forward_ios, color: mainColor,),
                ),
              ),
            ),
          ),
          new Visibility(visible: _devVisible, child: new Padding(padding: EdgeInsets.all(4.0))),
          new Visibility(
            visible: _devVisible,
            child: new GestureDetector(
              onTap: () {
                toChat("dev");
              },
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: Colors.white,
                elevation: 6.0,
                child: ListTile(
                  title: new Text("Developer Environment", style: TextStyle(fontSize: 15.0),),
                  trailing: Icon(Icons.arrow_forward_ios, color: mainColor,),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}