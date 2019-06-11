import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:vc_deca_flutter/screens/auth/auth_functions.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  Widget buttonChild = new Text("Login");

  void accountErrorDialog(String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Login Error"),
          content: new Text(
            "There was an error logging you in: $error",
            style: TextStyle(fontFamily: "Product Sans", fontSize: 14.0),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("GOT IT"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void login() async {
    setState(() {
      buttonChild = new HeartbeatProgressIndicator(
        child: Image.asset(
          'images/logo_white_trans.png',
          height: 15.0,
        ),
      );
    });
    try {
      FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      print("Signed in! ${user.uid}");
      userID = user.uid;
      await AuthFunctions.getUserData().then((bool retrievedData) {
        if (retrievedData) {
          print("Retrieved User Data");
          router.navigateTo(context, '/home', transition: TransitionType.fadeIn, clearStack: true);
        }
        else {
          print("Failed to Retrieve User Data");
          FirebaseAuth.instance.signOut();
          router.navigateTo(context, '/onboarding', transition: TransitionType.fadeIn, clearStack: true);
        }
      });
    }
    catch (error) {
      print("Error: ${error.details}");
      accountErrorDialog(error.details);
    }
    setState(() {
      buttonChild = new Text("Login");
    });
  }

  void emailField(input) {
    _email = input;
  }

  void passwordField(input) {
    _password = input;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "VC DECA",
          style: TextStyle(
              fontFamily: "Product Sans",
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: new Container(
        padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
        child: new Center(
          child: new ListView(
            children: <Widget>[
              new Text("Login to your VC DECA Account below!", style: TextStyle(fontFamily: "Product Sans",), textAlign: TextAlign.center,),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.email),
                    labelText: "Email",
                    hintText: "Enter your email"
                ),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                onChanged: emailField,
              ),
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.lock),
                    labelText: "Password",
                    hintText: "Enter a password"
                ),
                autocorrect: false,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                obscureText: true,
                onChanged: passwordField,
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new RaisedButton(
                child: buttonChild,
                onPressed: login,
                color: mainColor,
                textColor: Colors.white,
              ),
              new Padding(padding: EdgeInsets.all(16.0)),
              new FlatButton(
                child: new Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: mainColor,
                  ),
                ),
                splashColor: mainColor,
                onPressed: () {
                  router.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}