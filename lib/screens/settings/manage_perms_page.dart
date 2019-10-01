import 'dart:convert';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;

var json;

class ManagePermsPage extends StatefulWidget {
  @override
  _ManagePermsPageState createState() => _ManagePermsPageState();
}

class _ManagePermsPageState extends State<ManagePermsPage> {

  QRReaderController controller;
  List<String> tokens = new List();

  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    controller = new QRReaderController(cameras[0], ResolutionPreset.high, [CodeFormat.qr], (dynamic value) {
      getPermsFromQr(value.toString());
      new Future.delayed(const Duration(seconds: 3), controller.startScanning);
    });
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      controller.startScanning();
    });
  }

  void getPermsFromQr(String value) {
    try {
      json = jsonDecode(value);
      print(json);
      if (json["token"] != null && json["role"] != null && json["perms"] != null) {
        showModalBottomSheet(context: context, builder: (BuildContext context) {
          return new AddPermsDialog();
        });
      }
      else {
        print("Invalid QR Code");
        showModalBottomSheet(context: context, builder: (BuildContext context) {
          return new SafeArea(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new ListTile(),
                new Center(child: new Text("QR Code Not Valid", style: TextStyle(fontSize: 20.0, color: Colors.red),)),
                new ListTile(),
              ],
            ),
          );
        });
      }
    } catch (error) {
      print("Invalid QR Code");
      showModalBottomSheet(context: context, builder: (BuildContext context) {
        return new SafeArea(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new ListTile(),
              new Center(child: new Text("QR Code Not Valid", style: TextStyle(fontSize: 20.0, color: Colors.red),)),
              new ListTile(),
            ],
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Update Permissions"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new Visibility(
        visible: (userPerms.contains('ADMIN')),
        child: new FloatingActionButton.extended(
          label: new Text("CREATE CODE"),
          icon: Icon(Icons.add),
          onPressed: () {
            // TODO: Create QR Code Handler
          },
        ),
      ),
      backgroundColor: currBackgroundColor,
      body: new Container(
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: new QRReaderPreview(controller)
            ),
            new Positioned(
              top: MediaQuery.of(context).size.height / 5,
              right: MediaQuery.of(context).size.width / 2 - 75,
              child: new Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  border: Border.all(color: mainColor, width: 4.0),
                ),
              ),
            )
          ]
        )
      ),
    );
  }
}

class AddPermsDialog extends StatefulWidget {
  @override
  _AddPermsDialogState createState() => _AddPermsDialogState();
}

class _AddPermsDialogState extends State<AddPermsDialog> {

  List<String> tokens = new List();

  final databaseRef = FirebaseDatabase.instance.reference();

  bool _validToken = false;
  bool _invalidVisible = false;
  bool _finishedScan = false;

  _AddPermsDialogState() {
    refreshTokens().then((val) {
      if (tokens.contains(json["token"])) {
        print("Valid Token");
        _validToken = true;
      }
      else {
      print("Invalid Token");
        _invalidVisible = true;
      }
    });
  }

  Future refreshTokens() async {
    tokens.clear();
    try {
      await http.get("https://vc-deca.firebaseio.com/qrTokens/.json").then((response) {
        Map responseJson = jsonDecode(response.body);
        responseJson.keys.forEach((key) {
          setState(() {
            tokens.add(responseJson[key].toString());
          });
        });
      });
      print(tokens);
    }
    catch (error) {
      print("Failed to pull qrTokens! - $error");
      router.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Padding(padding: EdgeInsets.all(8.0)),
          new Visibility(visible: _invalidVisible, child: new Center(child: new Text("QR Code Not Valid", style: TextStyle(fontSize: 20.0, color: Colors.red),))),
          new Visibility(visible: _finishedScan, child: new Center(child: new Text("Updated User Permissions", style: TextStyle(fontSize: 20.0, color: Colors.green),))),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: new Text(
              json["role"],
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: (role != json["role"]) ? Colors.green : Colors.black
              ),
            ),
          ),
          new Expanded(
            child: new ListView.builder(
              itemCount: json["perms"].length,
              itemBuilder: (BuildContext context, int index) {
                return new ListTile(
                  title: new Text(json["perms"][index]),
                );
              },
            ),
          ),
          new Visibility(
            visible: !_finishedScan,
            child: new ListTile(
              leading: new FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                onPressed: () {
                  router.pop(context);
                },
                child: new Text("Cancel", style: TextStyle(fontFamily: "Product Sans", color: mainColor, fontSize: 18.0),),
              ),
              trailing: new Visibility(
                visible: !_invalidVisible,
                child: new RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  onPressed: () {
                    if (_validToken) {
                      for (int i = 0; i < json["perms"].length; i++) {
                        if (!userPerms.contains(json["perms"][i])) {
                          userPerms.add(json["perms"][i]);
                          databaseRef.child("users").child(userID).child("perms").push().set(json["perms"][i]);
                        }
                      }
                      role = json["role"];
                      databaseRef.child("users").child(userID).child("role").set(role);
                      print("Updated Role: $role");
                      print("Updated User Perms: ${userPerms.toString()}");
                      if (!json["token"].toString().contains("multi")) {
                        databaseRef.child("qrTokens").child(json["token"]).set(null);
                      }
                      setState(() {
                        _finishedScan = true;
                      });
                    }
                  },
                  color: mainColor,
                  child: new Text("Confirm", style: TextStyle(fontFamily: "Product Sans", color: Colors.white, fontSize: 18.0),),
                ),
              ),
            ),
          ),
          new Visibility(
            visible: _finishedScan,
            child: new ListTile(
              title: new Text("Done", style: TextStyle(fontFamily: "Product Sans", color: mainColor), textAlign: TextAlign.center,),
              onTap: () {
                router.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
