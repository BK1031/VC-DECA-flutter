import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';
import 'package:fluro/fluro.dart';
import 'user_info.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  
  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
  }
  
  void testUpload() {
    databaseRef.reference().child("testing").push().set({
      "Test": "$userID - $name"
    });
  }

  void signOutBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return SafeArea(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  title: new Text('Are you sure you want to sign out?'),
                ),
                new ListTile(
                  leading: new Icon(Icons.check),
                  title: new Text('Yes, sign me out!'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    router.navigateTo(context, '/notLogged', clearStack: true);
                  },
                  onLongPress: () {
                    print("long press");
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.clear),
                  title: new Text('Cancel'),
                  onTap: () {
                    router.pop(context);
                  },
                  onLongPress: () {

                  },
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.blue,
              height: 200.0,
              width: 1000.0,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Image.asset(
                    'images/vcdeca_white_trans.png',
                    width: 1000.0,
                    height: 125.0,
                  ),
                  new Text(
                    name,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              )
          ),
          new Container(
            padding: EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(email),
                  leading: Icon(Icons.email),
                ),
                new ListTile(
                  title: new Text(role),
                  leading: Icon(Icons.verified_user),
                ),
                new ListTile(
                  title: new Text("Help"),
                  leading: Icon(Icons.help),
                ),
                new ListTile(
                  title: new Text("Report a Bug"),
                  leading: Icon(Icons.bug_report),
                  onTap: () {
                    router.navigateTo(context, '/bugReport', transition: TransitionType.nativeModal);
                  },
                ),
                new ListTile(
                  title: new Text("Test Firebase Upload"),
                  leading: Icon(Icons.developer_mode),
                  onTap: testUpload,
                ),
                new ListTile(
                  title: new RaisedButton(
                    child: new Text("Sign Out"),
                    color: Colors.red,
                    textColor: Colors.white,
                    onPressed: signOutBottomSheetMenu,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
