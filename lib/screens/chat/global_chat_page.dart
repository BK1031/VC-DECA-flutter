import 'dart:async';
import 'dart:io';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vc_deca_flutter/main.dart';
import 'package:vc_deca_flutter/models/chat_message.dart';
import 'package:vc_deca_flutter/models/user.dart';
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
  bool _nsfw = false;

  Color sendColor = Colors.grey;

  Map<String, String> roleColors = {
    "Advisor": "#F6BB3B",
    "Chaperone": "#F6BB3B",
    "Officer": "#F6BB3B",
    "Cluster Mentor": "#F6BB3B",
    "Committee Member": "#F6BB3B",
    "Member": "#F6BB3B",
    "Bot": "#F6BB3B",
  };

  String type = "text";
  String message = "";

  bool canSendMessage = true;
  bool canDeleteMessage = false;

  _GlobalChatPageState() {
    databaseRef.child("chatColors").once().then((DataSnapshot snapshot) {
      setState(() {
        roleColors["Advisor"] = snapshot.value["advisorColor"];
        roleColors["Chaperone"] = snapshot.value["chaperoneColor"];
        roleColors["Officer"] = snapshot.value["officerColor"];
        roleColors["Cluster Mentor"] = snapshot.value["clusterColor"];
        roleColors["Committee Member"] = snapshot.value["committeeColor"];
        roleColors["Member"] = snapshot.value["memberColor"];
        roleColors["Bot"] = snapshot.value["botColor"];
      });
    });

    // Message Send & Delete Perms Check
    if (selectedChat == "global") {
      if (!userPerms.contains("CHAT_SEND")) {
        canSendMessage = false;
      }
      if (userPerms.contains("CHAT_DELTE")) {
        canDeleteMessage = true;
      }
    }

    if (selectedChat == "officer") {
      if (!userPerms.contains("OFFICER_CHAT_SEND")) {
        canSendMessage = false;
      }
      if (userPerms.contains("OFFICER_CHAT_DELETE")) {
        canDeleteMessage = true;
      }
    }

    if (selectedChat == "leader") {
      if (!userPerms.contains("LEADER_CHAT_SEND")) {
        canSendMessage = false;
      }
      if (userPerms.contains("LEADER_CHAT_DELETE")) {
        canDeleteMessage = true;
      }
    }

    if (userPerms.contains("ADMIN") || userPerms.contains("DEV")) {
      canDeleteMessage = true;
    }

    databaseRef.child("chatNoNoWords").onChildAdded.listen((Event event) {
      noNoWordList.add(event.snapshot.value.toString());
    });
    databaseRef.child("chat").child(selectedChat).onChildAdded.listen(onNewMessage);
  }

  void showMessageDetails(int index) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(context: context, builder: (BuildContext context) {
        return new CupertinoActionSheet(
          title: new Text("Message Options"),
          message: new Text(messageList[index].message),
          actions: <Widget>[
            new CupertinoActionSheetAction(
              child: new Text("Copy Message ID"),
              onPressed: () {
                Clipboard.setData(new ClipboardData(text: messageList[index].key));
              },
            ),
            new CupertinoActionSheetAction(
              child: new Text(messageList[index].timestamp),
              onPressed: () {
                Clipboard.setData(new ClipboardData(text: messageList[index].timestamp));
              },
            ),
            new CupertinoActionSheetAction(
              child: new Text("Report"),
              onPressed: () {
                databaseRef.child("chat").child("reports").child(selectedChat).child(messageList[index].key).set(messageList[index].message);
                Navigator.pop(context);
              },
            ),
            new Visibility(
              visible: canDeleteMessage,
              child: new CupertinoActionSheetAction(
                child: new Text("Delete Message"),
                isDestructiveAction: true,
                onPressed: () {
                  databaseRef.child("chat").child(selectedChat).child(messageList[index].key).set(null);
                  setState(() {
                    messageList.removeAt(index);
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
          cancelButton: new CupertinoActionSheetAction(
            child: const Text("Cancel"),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          )
        );
      });
    }
    else if (Platform.isAndroid) {
      showModalBottomSheet(context: context, builder: (BuildContext context) {
        return new SafeArea(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                title: new Text('Message Options', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              new ListTile(
                title: new Text(messageList[index].message),
              ),
              new ListTile(
                  leading: new Icon(Icons.vpn_key),
                  title: new Text("Copy Message ID"),
                  onTap: () {
                    Clipboard.setData(new ClipboardData(text: messageList[index].key));
                  }
              ),
              new ListTile(
                  leading: new Icon(Icons.access_time),
                  title: new Text(messageList[index].timestamp),
                  onTap: () {
                    Clipboard.setData(new ClipboardData(text: messageList[index].timestamp));
                  }
              ),
              new ListTile(
                leading: new Icon(Icons.report),
                title: new Text('Report'),
                onTap: () {
                  databaseRef.child("chat").child("reports").child(selectedChat).child(messageList[index].key).set(messageList[index].message);
                  Navigator.pop(context);
                }
              ),
              new ListTile(
                  leading: new Icon(Icons.delete),
                  title: new Text('Delete Message'),
                  onTap: () {
                    databaseRef.child("chat").child(selectedChat).child(messageList[index].key).set(null);
                    setState(() {
                      messageList.removeAt(index);
                    });
                    Navigator.pop(context);
                  }
              ),
              new ListTile(
                leading: new Icon(Icons.clear),
                title: new Text('Cancel'),
                onTap: () {
                  router.pop(context);
                },
              ),
            ],
          ),
        );
      });
    }
  }

  onNewMessage(Event event) async {
    if (event.snapshot.value["nsfw"]) {
      // This message contains a No No Word
      if (role != "Advisor" && role != "Chaperone") {
        setState(() {
          messageList.add(new ChatMessage.fromSnapshot(event.snapshot, false));
        });
      }
    }
    else {
      if (messageList.length >= 1 && messageList.last.authorID == event.snapshot.value["userID"]) {
        setState(() {
          messageList.add(new ChatMessage.fromSnapshot(event.snapshot, true));
        });
      }
      else {
        setState(() {
          messageList.add(new ChatMessage.fromSnapshot(event.snapshot, false));
        });
      }
    }
    await new Future.delayed(const Duration(milliseconds: 300));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 10.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void sendMessage() {
    if (message != "" && message != " " && message != "  " && message != "  ") {
      // Configure message color
      String messageColor = "";
      if (customChatColor != "") {
        messageColor = customChatColor;
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
        "profileUrl": profilePic,
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

  void sendImage() {
    if (Platform.isIOS) {
      showCupertinoModalPopup(context: context, builder: (BuildContext context) {
        return new CupertinoActionSheet(
            actions: <Widget>[
              new CupertinoActionSheetAction(
                child: new Text("Take Photo"),
                onPressed: takePhoto
              ),
              new CupertinoActionSheetAction(
                  child: new Text("Photo Library"),
                  onPressed: pickImage
              )
            ],
            cancelButton: new CupertinoActionSheetAction(
              child: const Text("Cancel"),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            )
        );
      });
    }
    else if (Platform.isAndroid) {
      showModalBottomSheet(context: context, builder: (BuildContext context) {
        return new SafeArea(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.camera_alt),
                title: new Text('Take Photo'),
                onTap: takePhoto,
              ),
              new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text('Photo Library'),
                onTap: pickImage,
              ),
              new ListTile(
                leading: new Icon(Icons.clear),
                title: new Text('Cancel'),
                onTap: () {
                  router.pop(context);
                },
              ),
            ],
          ),
        );
      });
    }
  }

  Future<void> pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      showDialog(
        barrierDismissible: false,
        context: context,
        child: new AlertDialog(
          content: new SendImageDialog(image),
        )
      );
    }
  }

  Future<void> takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return new SendImageDialog(image);
          },
      );
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

  void showUserSheet(String userID, String roleColor) {
    showModalBottomSheet(context: context, builder: (context) {
      return new UserInfoSheet(userID, roleColor);
    });
  }
  
  Widget getMessageBody(int index) {
    if (messageList[index].mediaType == "text") {
      return new Container(
        padding: (messageList[index].repeatAuthor) ? EdgeInsets.only(top: 8.0) : EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(right: 8.0, left: 8.0),
              child: new InkWell(
                onTap: () {
                  showUserSheet(messageList[index].authorID, roleColors[messageList[index].authorRole]);
                },
                child: new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  child: new CachedNetworkImage(
                    imageUrl: messageList[index].profileUrl,
                    height: (messageList[index].repeatAuthor) ? 0.0 : 50.0,
                    width: 50.0,
                  ),
                ),
              ),
            ),
            new Expanded(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    child: new InkWell(
                      onLongPress: () {
                        showMessageDetails(index);
                      },
                      onTap: () {
                        showUserSheet(messageList[index].authorID, roleColors[messageList[index].authorRole]);
                      },
                      child: new Visibility(
                        visible: !messageList[index].repeatAuthor,
                        child: new Text(
                          messageList[index].author,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: (messageList[index].customColor != "") ? HexColor(messageList[index].customColor) : HexColor(roleColors[messageList[index].authorRole])
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Visibility(visible: !messageList[index].repeatAuthor, child: new Padding(padding: EdgeInsets.all(2.0)),),
                  new Container(
                    child: new InkWell(
                      onLongPress: () {
                        showMessageDetails(index);
                      },
                      child: new Linkify(
                        onOpen: (url) async {
                          if (await canLaunch(url.url)) {
                            await launch(url.url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        text: messageList[index].message,
                        style: TextStyle(fontSize: 15.0, color: currTextColor),
                        linkStyle: TextStyle(
                            fontFamily: "Product Sans",
                            color: (messageList[index].customColor != "") ? HexColor(messageList[index].customColor) : HexColor(roleColors[messageList[index].authorRole]),
                            fontSize: 15.0
                        ),
                      ),
                    ),
                  ),
//                  new Visibility(visible: messageList[index].repeatAuthor, child: new Padding(padding: EdgeInsets.all(4.0)))
                ],
              ),
            ),
          ],
        ),
      );
    }
    else if (messageList[index].mediaType == "image") {
      return new Container(
        padding: (messageList[index].repeatAuthor) ? EdgeInsets.only(top: 8.0) : EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(right: 8.0, left: 8.0),
              child: new InkWell(
                onTap: () {
                  showUserSheet(messageList[index].authorID, roleColors[messageList[index].authorRole]);
                },
                child: new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  child: new CachedNetworkImage(
                    imageUrl: messageList[index].profileUrl,
                    height: (messageList[index].repeatAuthor) ? 0.0 : 50.0,
                    width: 50.0,
                  ),
                ),
              ),
            ),
            new Expanded(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    child: new InkWell(
                      onLongPress: () {
                        showMessageDetails(index);
                      },
                      onTap: () {
                        showUserSheet(messageList[index].authorID, roleColors[messageList[index].authorRole]);
                      },
                      child: new Visibility(
                        visible: !messageList[index].repeatAuthor,
                        child: new Text(
                          messageList[index].author,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: (messageList[index].customColor != "") ? HexColor(messageList[index].customColor) : HexColor(roleColors[messageList[index].authorRole])
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Visibility(visible: !messageList[index].repeatAuthor, child: new Padding(padding: EdgeInsets.all(2.0)),),
                  new Container(
                    child: new InkWell(
                      onLongPress: () {
                        showMessageDetails(index);
                      },
                      onTap: () {
                        selectedImage = messageList[index].message;
                        router.navigateTo(context, '/conference/details/media-view', transition: TransitionType.nativeModal);
                      },
                      child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        child: new CachedNetworkImage(
                          imageUrl: messageList[index].message,
                          placeholder: (context, url) => new Container(
                            child: new GlowingProgressIndicator(
                              child: new Image.asset('images/logo_blue_trans.png', height: 75.0,),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
//                  new Visibility(visible: messageList[index].repeatAuthor, child: new Padding(padding: EdgeInsets.all(4.0)))
                ],
              ),
            ),
          ],
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: currBackgroundColor,
      body: new SafeArea(
        child: Column(
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(4.0)),
            new Expanded(
              child: new Container(
                padding: EdgeInsets.only(right: 16.0),
                child: new ListView.builder(
                  itemCount: messageList.length,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return getMessageBody(index);
                  },
                ),
              ),
            ),
            new Visibility(
              visible: !canSendMessage,
              child: Container(
                child: new Text("It looks like you don't have permission to send messages in the this chat!\n\nIf this is a mistake, please contact the admin."),
                padding: EdgeInsets.all(15.0),
              ),
            ),
            new Visibility(
              visible: canSendMessage,
              child: new Container(
                padding: EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
                child: new Card(
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  child: new ListTile(
                      title: Container(
                        child: Row(
                          children: <Widget>[
                            // Button send image
                            Material(
                              child: new Container(
                                child: new IconButton(
                                  icon: new Icon(Icons.image),
                                  color: Colors.grey,
                                  onPressed: () {
                                    sendImage();
                                  },
                                ),
                              ),
                              color: currCardColor,
                            ),
                            // Edit text
                            Flexible(
                              child: Container(
                                child: TextField(
                                  controller: myController,
                                  textInputAction: TextInputAction.newline,
                                  textCapitalization: TextCapitalization.sentences,
                                  style: TextStyle(fontFamily: "Product Sans", color: currTextColor, fontSize: 15.0),
                                  decoration: InputDecoration.collapsed(
                                      hintText: 'Type your message...',
                                      hintStyle: TextStyle(fontFamily: "Product Sans", color: darkMode ? Colors.grey : Colors.black54)
                                  ),
                                  focusNode: myFocusNode,
                                  onChanged: textChanged,
                                ),
                              ),
                            ),
                            new Material(
                              child: new Container(
                                child: new IconButton(
                                    icon: new Icon(Icons.send),
                                    color: sendColor,
                                    onPressed: sendMessage
                                ),
                              ),
                              color: currCardColor,
                            )
                          ],
                        ),
                        width: double.infinity,
                        height: 50.0,
                      )
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class UserInfoSheet extends StatefulWidget {

  String userID;
  String roleColor;

  UserInfoSheet(String userID, String roleColor) {
    this.userID = userID;
    this.roleColor = roleColor;
  }

  @override
  _UserInfoSheetState createState() => _UserInfoSheetState(userID, roleColor);
}

class _UserInfoSheetState extends State<UserInfoSheet> {

  String userID;
  String roleColor = "#0073CE";
  DataSnapshot userSnapshot;

  String name = "";
  String email = "";

  _UserInfoSheetState(String userID, String roleColor) {
    this.userID = userID;
    this.roleColor = roleColor;
    FirebaseDatabase.instance.reference().child("users").child(userID).once().then((DataSnapshot snapshot) {
      userSnapshot = snapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: Container(
        padding: EdgeInsets.only(right: 16.0, top: 16.0, left: 16.0),
        color: currBackgroundColor,
        child: new SingleChildScrollView(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(150.0)),
                child: new CachedNetworkImage(
                  imageUrl: userSnapshot.value["profilePicUrl"],
                  height: 100.0,
                ),
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Text(
                userSnapshot.value["name"],
                style: TextStyle(fontSize: 25.0, color: currTextColor),
              ),
              new Padding(padding: EdgeInsets.all(4.0)),
              new Text(
                userSnapshot.value["email"],
                style: TextStyle(fontSize: 17.0, color: currTextColor),
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Wrap(
                children: <Widget>[
                  new Visibility(
                    visible: (userSnapshot.value.toString().contains("DEV")),
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: mainColor,
                      elevation: 6.0,
                      child: new Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0, top: 4.0),
                        child: new Center(
                          child: new Text(
                            "Developer",
                            style: TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Visibility(
                    visible: (userSnapshot.value["title"] != ""),
                    child: new Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: (userSnapshot.value["chatColor"] != "") ? HexColor(userSnapshot.value["chatColor"]) : HexColor(roleColor),
                      elevation: 6.0,
                      child: new Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0, top: 4.0),
                        child: new Center(
                          child: new Text(
                            userSnapshot.value["title"],
                            style: TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: HexColor(roleColor),
                    elevation: 6.0,
                    child: new Container(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0, top: 4.0),
                      child: new Center(
                        child: new Text(
                          userSnapshot.value["role"],
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new Visibility(
                visible: (userPerms.contains("ADMIN") || userPerms.contains("DEV")),
                child: new Card(
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  child: Column(
                    children: <Widget>[
                      new Visibility(
                        visible: (userPerms.contains("ADMIN")),
                        child: new ListTile(
                          leading: new Icon(Icons.settings, color: darkMode ? Colors.grey : Colors.black54),
                          title: new Text("Manage", style: TextStyle(color: currTextColor),),
                          trailing: Icon(Icons.arrow_forward_ios, color: mainColor,),
                          onTap: () {
                            // TODO: Add user management stuff
                          },
                        ),
                      ),
                      new Visibility(
                        visible: (userPerms.contains("DEV")),
                        child: new ListTile(
                          leading: new Icon(Icons.person, color: darkMode ? Colors.grey : Colors.black54),
                          title: new Text("User Details", style: TextStyle(color: currTextColor),),
                          trailing: Icon(Icons.arrow_forward_ios, color: mainColor,),
                          onTap: () {
                            // TODO: Add user details stuff
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new Visibility(visible: (userPerms.contains("ADMIN") || userPerms.contains("DEV")), child: new Padding(padding: EdgeInsets.all(8.0))),
            ],
          ),
        ),
      ),
    );
  }
}

class SendImageDialog extends StatefulWidget {
  var image;
  SendImageDialog(image) {this.image = image;}
  @override
  _SendImageDialogState createState() => _SendImageDialogState(image);
}

class _SendImageDialogState extends State<SendImageDialog> {

  var image;
  bool _uploading = false;
  double _progress = 0.0;

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  _SendImageDialogState(image) {
    this.image = image;
  }

  Future<void> uploadImage() async {
    String messageColor = "";
    if (customChatColor != "") {
      messageColor = customChatColor;
    }
    setState(() {
      _uploading = true;
    });
    print("UPLOADING");
    StorageUploadTask imageUploadTask = storageRef.child("chat").child(selectedChat).child("${new DateTime.now()}.png").putFile(image);
    imageUploadTask.events.listen((event) {
      print("UPLOADING: ${event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble()}");
      setState(() {
        _progress = event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble();
      });
    });
    var downurl = await (await imageUploadTask.onComplete).ref.getDownloadURL();
    var url = downurl.toString();
    databaseRef.child("chat").child(selectedChat).push().update({
      "author": name,
      "message": url,
      "userID": userID,
      "date": new DateFormat('MM/dd/yyyy hh:mm aaa').format(new DateTime.now()),
      "role": role,
      "type": "image",
      "color": messageColor,
      "profileUrl": profilePic,
      "nsfw": false
    });
    router.pop(context);
  }

    @override
  Widget build(BuildContext context) {
    return Container(
      color: currCardColor,
//      color: Colors.greenAccent,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Image.file(image),
          new Padding(padding: EdgeInsets.all(8.0)),
          new Visibility(
            visible: !_uploading,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    child: new Text("CANCEL"),
                    textColor: mainColor,
                    onPressed: () {
                      router.pop(context);
                    },
                  ),
                ),
                new Expanded(
                  child: new RaisedButton.icon(
                    icon: new Icon(Icons.send),
                    label: new Text("SEND"),
                    color: mainColor,
                    textColor: Colors.white,
                    onPressed: uploadImage
                  ),
                ),
              ],
            ),
          ),
          new Visibility(
            visible: _uploading,
            child: new LinearProgressIndicator(
              value: _progress,
            ),
          )
        ],
      ),
    );
  }
}
