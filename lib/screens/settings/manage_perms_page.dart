import 'dart:convert';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
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
    json = jsonDecode(value);
    print(json);
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return new AddPermsDialog();
    });
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
      backgroundColor: currBackgroundColor,
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new AspectRatio(
                aspectRatio: controller.value.aspectRatio*5,
                child: new QRReaderPreview(controller)
              )
            ),
            new Container(
              height: 200.0,
            )
          ],
        ),
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

  _AddPermsDialogState() {
    refreshTokens().then((val) {
      if (tokens.contains(json["token"])) {
        print("Valid Token");
        _validToken = true;
      }
      else {

      }
    });
  }

  Future refreshTokens() async {
    tokens.clear();
    try {
      await http.get(getDbUrl("qrTokens")).then((response) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            role,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          new Text(
            json["perms"].toString(),
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
          ),
          new ListTile(
            leading: new FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              onPressed: () {
                router.pop(context);
              },
              child: new Text("Cancel", style: TextStyle(fontFamily: "Product Sans", color: mainColor, fontSize: 18.0),),
            ),
            trailing: new RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              onPressed: () {
                if (_validToken) {
//                  databaseRef.child("qrTokens").
                  router.pop(context);
                }
              },
              color: mainColor,
              child: new Text("Confirm", style: TextStyle(fontFamily: "Product Sans", color: Colors.white, fontSize: 18.0),),
            ),
          ),
        ],
      ),
    );
  }
}
