import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:vc_deca/user_info.dart';
import 'package:fluro/fluro.dart';

class ConnectionChecker extends StatefulWidget {
  @override
  _ConnectionCheckerState createState() => _ConnectionCheckerState();
}

class _ConnectionCheckerState extends State<ConnectionChecker> {

  final connectionRef = FirebaseDatabase.instance.reference().child(".info/connected");

  Future<void> checkConnection() async {
    connectionRef.onValue.listen(connectionListener);
  }

  connectionListener(Event event) {
    print(event.snapshot.value);
    if (event.snapshot.value) {
      print("Connected");
      router.navigateTo(context, '/checkAuth', transition: TransitionType.fadeIn, replace: true);
    }
    else {
      print("Not Connected");
      router.navigateTo(context, '/checkConnectionAgain', transition: TransitionType.fadeIn, replace: true);
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnection();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0, top: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'images/vcdeca_blue_trans.png',
              ),
              new Text(
                "Server Connection Error",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.red,
                  decoration: TextDecoration.none,
                  fontSize: 35.0,
                ),
              ),
              new Padding(padding: EdgeInsets.all(16.0)),
              new Text(
                "We encountered a problem when trying to connect you to our servers. This page will automatically disappear if a connection with the server is established.\n\nTroubleshooting Tips:\n- Check your wireless connection\n- Restart the VC DECA app\n- Restart your device",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontSize: 17.0,
                    fontWeight: FontWeight.normal
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
