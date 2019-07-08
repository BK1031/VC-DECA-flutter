import 'package:fluro/fluro.dart';
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
              // TODO: Implement Mentor Group Handler
            },
            child: new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: Colors.white,
              elevation: 6.0,
              child: ListTile(
                title: new Text("Mentor Group", style: TextStyle(fontSize: 15.0),),
                trailing: Icon(Icons.arrow_forward_ios, color: mainColor,),
              ),
            ),
          ),
          new Padding(padding: EdgeInsets.all(4.0)),
          new GestureDetector(
            onTap: () {
              // TODO: Implement Chaperone Group Handler
            },
            child: new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: Colors.white,
              elevation: 6.0,
              child: ListTile(
                title: new Text("Chaperone Group", style: TextStyle(fontSize: 15.0),),
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
