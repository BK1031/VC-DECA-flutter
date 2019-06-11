import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  bool _chatVisible = false;
  bool _officerVisible = false;
  bool _budgetVisible = false;

  _ChatPageState() {
    if (userPerms.contains("CHAT_VIEW")) {
      _chatVisible = true;
    }
    if (userPerms.contains("OFFICER_VIEW")) {
      _officerVisible = true;
    }
    if (userPerms.contains("BUDGET_VIEW")) {
      _budgetVisible = true;
    }
  }

  void toChat(String chatRef) {
    selectedChat = chatRef;
    if (chatRef == "global") {
      chatTitle = "General Chat";
    }
    router.navigateTo(context, '/chat/global', transition: TransitionType.native);
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
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  width: double.infinity,
                  child: new Text("General Chat", style: TextStyle(fontSize: 15.0),)
                ),
              ),
            ),
          ),
          new Padding(padding: EdgeInsets.all(4.0)),
          new Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
            color: Colors.white,
            elevation: 6.0,
            child: Container(
                padding: EdgeInsets.all(16.0),
                width: double.infinity,
                child: new Text("Mentor Group", style: TextStyle(fontSize: 15.0),)
            ),
          ),
          new Padding(padding: EdgeInsets.all(4.0)),
          new Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
            color: Colors.white,
            elevation: 6.0,
            child: Container(
                padding: EdgeInsets.all(16.0),
                width: double.infinity,
                child: new Text("Chaperone Group", style: TextStyle(fontSize: 15.0),)
            ),
          ),
          new Padding(padding: EdgeInsets.all(4.0)),
          new Visibility(
            visible: _officerVisible,
            child: new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: Colors.white,
              elevation: 6.0,
              child: Container(
                  padding: EdgeInsets.all(16.0),
                  width: double.infinity,
                  child: new Text("Officer Chat", style: TextStyle(fontSize: 15.0),)
              ),
            ),
          ),
          new Padding(padding: EdgeInsets.all(4.0)),
          new Visibility(
            visible: _budgetVisible,
            child: new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: Colors.white,
              elevation: 6.0,
              child: Container(
                  padding: EdgeInsets.all(16.0),
                  width: double.infinity,
                  child: new Text("Leader Chat", style: TextStyle(fontSize: 15.0),)
              ),
            ),
          )
        ],
      ),
    );
  }
}
