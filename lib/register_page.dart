import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_info.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String _name = "";
  String _email = "";
  String _password = "";
  String _confirm = "";

  final databaseRef = FirebaseDatabase.instance.reference();

  void register() async {
    if (_name == "") {
      print("Name cannot be empty");
    }
    else if (_password != _confirm) {
      print("Password don't match");
    }
    else if (_email == "") {
      print("Email cannot be empty");
    }
    else {
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        print("Signed in! ${user.uid}");

        name = _name;
        email = _email;
        userID = user.uid;
        role = "Member";

        databaseRef.child("users").child(userID).update({
          "name": name,
          "email": email,
          "role": role,
          "userID": userID,
          "group": "Not in a Group"
        });

        router.navigateTo(context,'/registered', transition: TransitionType.fadeIn, clearStack: true);
      }
      catch (error) {
        print("Error: $error");
      }
    }
  }

  void nameField(input) {
    _name = input;
  }

  void emailField(input) {
    _email = input;
  }

  void passwordField(input) {
    _password = input;
  }

  void confirmField(input) {
    _confirm = input;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "VC DECA",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: new Container(
        padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text("Create your VC DECA Account below!"),
              new Padding(padding: EdgeInsets.all(8.0)),
              new TextField(
                decoration: InputDecoration(
                  icon: new Icon(Icons.person),
                  labelText: "Name",
                  hintText: "Enter your name"
                ),
                autocorrect: true,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: nameField,
              ),
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
              new TextField(
                decoration: InputDecoration(
                    icon: new Icon(Icons.lock),
                    labelText: "Confirm Password",
                    hintText: "Confirm your password"
                ),
                autocorrect: false,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                obscureText: true,
                onChanged: confirmField,
              ),
              new Padding(padding: EdgeInsets.all(8.0)),
              new RaisedButton(
                child: new Text("Create Account"),
                onPressed: register,
                color: Colors.blue,
                textColor: Colors.white,
                highlightColor: Colors.blue,
              ),
              new Padding(padding: EdgeInsets.all(16.0)),
              new FlatButton(
                child: new Text(
                  "Already have an account?",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                splashColor: Colors.blue,
                onPressed: () {
                  router.navigateTo(context,'/toLogin', transition: TransitionType.inFromRight);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
