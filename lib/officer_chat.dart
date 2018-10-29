import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'user_info.dart';
import 'package:firebase_database/firebase_database.dart';

class OfficerChatPage extends StatefulWidget {
  @override
  _OfficerChatPageState createState() => _OfficerChatPageState();
}

class ChatMessage {
  String key;
  String message;
  String author;

  ChatMessage(this.message, this.author);

  ChatMessage.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        message = snapshot.value["message"].toString(),
        author = snapshot.value["author"].toString();

  toJson() {
    return {
      "message": message,
      "author": author
    };
  }
}

class _OfficerChatPageState extends State<OfficerChatPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final myController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<ChatMessage> messageList = new List();
  var listSize;

  _OfficerChatPageState() {
    databaseRef.child("chat").child("officer").onChildAdded.listen(onNewMessage);
  }

  onNewMessage(Event event) async {
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

  onMessageDeletion(Event event) {
    var oldValue =
    messageList.singleWhere((entry) => entry.key == event.snapshot.key);
    setState(() {
      messageList.removeAt(messageList.indexOf(oldValue));
    });
  }

  void onMessageType(String input) {
    setState(() {
      listSize = MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 1.5);
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void sendMessage(String input) {
    if (input != "" && input != " ") {
      databaseRef.child("chat").child("officer").push().update({
        "author": name,
        "message": input,
      });
    }
    setState(() {
      listSize = MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height / 4);
    });
    myController.clear();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 10,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  TextAlign getAlignment(String messageAuthor) {
    if (messageAuthor == name) {
      return TextAlign.end;
    }
    else {
      return TextAlign.start;
    }
  }

  Color getColor(String messageAuthor) {
    if (messageAuthor == name) {
      return Colors.blue;
    }
    else {
      return Colors.black;
    }
  }

  @override
  void initState() {
    super.initState();
    listSize = 500.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: new Text("Officers"),
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: new Container(
        color: Colors.white,
        height: 100.0,
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
        child: new TextField(
          controller: myController,
          textInputAction: TextInputAction.send,
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: sendMessage,
          onChanged: onMessageType,
          decoration: InputDecoration(
            labelText: "Enter Message",
            hintText: "Type a new message to send"
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: new SafeArea(
        child: new Container(
          color: Colors.white,
          height: listSize,
          padding: EdgeInsets.all(16.0),
          child: new ListView.builder(
            itemCount: messageList.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: ListTile(
                  title: new Text(
                    messageList[index].message,
                    textAlign: getAlignment(messageList[index].author),
                    style: TextStyle(
                      color: getColor(messageList[index].author),
                      fontSize: 15.0
                    ),
                  ),
                  subtitle: new Text(
                    messageList[index].author,
                    textAlign: getAlignment(messageList[index].author),
                    style: TextStyle(
//                      color: getColor(messageList[index].author),
                      fontSize: 12.0
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
