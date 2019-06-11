import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vc_deca_flutter/models/chat_message.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/hex_color.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import 'package:intl/intl.dart';

import '../../user_info.dart';

class GlobalChatPage extends StatefulWidget {
  @override
  _GlobalChatPageState createState() => _GlobalChatPageState();
}

class _GlobalChatPageState extends State<GlobalChatPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();
  final myController = new TextEditingController();
  FocusNode myFocusNode = new FocusNode();
  ScrollController _scrollController = new ScrollController();
  List<ChatMessage> messageList = new List();
  List<String> noNoWordList = new List();
  bool _visible = false;
  bool _nsfw = false;

  Color sendColor = Colors.grey;

  String memberColor = "#F6BB3B";
  String officerColor = "#F6BB3B";
  String botColor = "#F6BB3B";
  String advisorColor = "#F6BB3B";
  String chaperoneColor = "#F6BB3B";

  String type = "text";
  String message = "";

  _GlobalChatPageState() {
    databaseRef.child("chatColors").once().then((DataSnapshot snapshot) {
      setState(() {
        memberColor = snapshot.value["memberColor"];
        officerColor = snapshot.value["officerColor"];
        botColor = snapshot.value["botColor"];
        advisorColor = snapshot.value["advisorColor"];
        chaperoneColor = snapshot.value["chaperoneColor"];
      });
    });

    databaseRef.child("chat").child(selectedChat).onChildAdded.listen(onNewMessage);

    databaseRef.child("chatNoNoWords").onChildAdded.listen((Event event) {
      noNoWordList.add(event.snapshot.value.toString());
    });
  }

  onNewMessage(Event event) async {
    if (event.snapshot.value["nsfw"]) {
      // This message contains a No No Word
      if (role != "Advisor" && role != "Chaperone") {
        setState(() {
          messageList.add(new ChatMessage.fromSnapshot(event.snapshot));
        });
        await new Future.delayed(const Duration(milliseconds: 300));
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 10.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
    else {
      if (messageList.length > 1 && messageList.last.authorID == event.snapshot.value["userID"]) {
        setState(() {
          messageList.last.message += "\n\n${event.snapshot.value["message"]}";
        });
      }
      else {
        setState(() {
          messageList.add(new ChatMessage.fromSnapshot(event.snapshot));
        });
      }
      await new Future.delayed(const Duration(milliseconds: 300));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 10.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void sendMessage() {
    if (message != "" && message != " " && message != "  " && message != "  ") {
      // Configure message color
      String messageColor = "#F6BB3B";
      if (userPerms.contains("DEV") && customChatColor != "") {
        messageColor = customChatColor;
      }
      else {
        // Default to role-based color scheme
        if (role == "Officer") {
          messageColor = officerColor;
        }
        else if (role == "Advisor") {
          messageColor = advisorColor;
        }
        else if (role == "Chaperone") {
          messageColor = chaperoneColor;
        }
        else {
          messageColor = memberColor;
        }
      }
      // Check for nsfw content
      noNoWordList.forEach((badWord) {
        if (message.toLowerCase().contains(badWord)) {
          _nsfw = true;
          print("nsfw content detected");
        }
      });
      // Send message
      databaseRef.child("chat").child(selectedChat).push().update({
        "author": name,
        "message": message,
        "userID": userID,
        "date": new DateFormat('MM/dd/yyyy hh:mm aaa').format(new DateTime.now()),
        "role": role,
        "type": type,
        "color": messageColor,
        "nsfw": _nsfw
      });
      myController.clear();
      setState(() {
        message = "";
        sendColor = Colors.grey;
      });
      _nsfw = false;
    }
  }

  void textChanged(String input) {
    if (input != "" && input != " " && input != "  " && input != "  ") {
      type = "text";
      setState(() {
        message = input;
        sendColor = mainColor;
      });
    }
    else {
      type = "";
      setState(() {
        message = input;
        sendColor = Colors.grey;
      });
    }
  }

  bool getVisibility(String authorRole, String messageAuthor) {
    if (messageAuthor == name && authorRole == role) {
      return false;
    }
    else if (authorRole == "Member") {
      return false;
    }
    else {
      return true;
    }
  }

  Widget getMessageBody(int index) {
    if (messageList[index].mediaType == "text") {
      return new Linkify(
        onOpen: (url) async {
          if (await canLaunch(url.url)) {
            await launch(url.url);
          } else {
            throw 'Could not launch $url';
          }
        },
        text: messageList[index].message,
        linkStyle: TextStyle(
            fontFamily: "Product Sans",
            color: HexColor(messageList[index].messageColor),
            fontSize: 16.0
        ),
        style: TextStyle(
            fontFamily: "Product Sans",
            color: Colors.black,
            fontSize: 16.0
        ),
      );
    }
    else {
      return new Container(
        padding: EdgeInsets.all(8.0),
        child: new ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: new CachedNetworkImage(
            imageUrl: messageList[index].message,
            height: 300.0,
            width: 300.0,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  Future<Null> focusNodeListener() async {
    if (myFocusNode.hasFocus) {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 10.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(focusNodeListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text(chatTitle),
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 25.0,
                fontFamily: "Product Sans",
                fontWeight: FontWeight.bold
            )
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.white,
      body: new SafeArea(
        child: Column(
          children: <Widget>[
            new Expanded(
              child: new Container(
                padding: EdgeInsets.all(8.0),
                child: new ListView.builder(
                  itemCount: messageList.length,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: new BoxDecoration(
                          border: new Border(
                              left: new BorderSide(
                                color: HexColor(messageList[index].messageColor),
                                width: 3.0,
                              )
                          ),
                        ),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text(
                                  messageList[index].author,
                                  style: TextStyle(
                                      fontFamily: "Product Sans",
                                      color: HexColor(messageList[index].messageColor),
                                      fontSize: 16.0
                                  ),
                                ),
                                new Padding(padding: EdgeInsets.all(4.0)),
                                new Visibility(
                                  visible: getVisibility(messageList[index].authorRole, messageList[index].author),
                                  child: new Card(
                                      color: HexColor(messageList[index].messageColor),
                                      child: new Container(
                                        padding: EdgeInsets.all(4.0),
                                        child: new Text(
                                          messageList[index].authorRole,
                                          style: TextStyle(
                                              fontFamily: "Product Sans",
                                              color: Colors.white,
                                              fontSize: 16.0
                                          ),
                                        ),
                                      )
                                  ),
                                )
                              ],
                            ),
                            getMessageBody(index)
                          ],
                        )
                    );
                  },
                ),
              ),
            ),
            new ListTile(
                title: Container(
                  child: Row(
                    children: <Widget>[
                      // Button send image
                      Material(
                        child: new Container(
                          margin: new EdgeInsets.symmetric(horizontal: 1.0),
                          child: new IconButton(
                            icon: new Icon(Icons.image),
                            color: Colors.grey,
                            onPressed: () {
                              // TODO: Implement Image Sending
                            },
                          ),
                        ),
                        color: Colors.white,
                      ),
                      // Edit text
                      Flexible(
                        child: Container(
                          child: TextField(
                            controller: myController,
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(fontFamily: "Product Sans", color: Colors.black, fontSize: 16.0),
                            decoration: InputDecoration.collapsed(
                                hintText: 'Type your message...',
                                hintStyle: TextStyle(fontFamily: "Product Sans")
                            ),
                            focusNode: myFocusNode,
                            onChanged: textChanged,
                          ),
                        ),
                      ),
                      new Material(
                        child: new Container(
                          margin: new EdgeInsets.symmetric(horizontal: 8.0),
                          child: new IconButton(
                              icon: new Icon(Icons.send),
                              color: sendColor,
                              onPressed: sendMessage
                          ),
                        ),
                        color: Colors.white,
                      )
                    ],
                  ),
                  width: double.infinity,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      border: new Border(top: new BorderSide(color: mainColor, width: 0.5)), color: Colors.white),
                )
            )
          ],
        ),
      ),
    );
  }
}