import 'package:flutter/material.dart';
import 'user_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluro/fluro.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void deleteAccountBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return SafeArea(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  title: new Text('Are you sure you want to delete your VC DECA Account?'),
                ),
                new ListTile(
                  leading: new Icon(Icons.check),
                  title: new Text('Yes, delete my account!'),
                  onTap: () {

                  },
                  onLongPress: () {},
                ),
                new ListTile(
                  leading: new Icon(Icons.clear),
                  title: new Text('Cancel'),
                  onTap: () {
                    router.pop(context);
                  },
                  onLongPress: () {},
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          new Card(
            color: primaryColor,
            child: Column(
              children: <Widget>[
                new Container(
                  width: 1000.0,
                  padding: EdgeInsets.all(16.0),
                  child: new Text(
                    name,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                new Container(
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new Text("Email"),
                        trailing: new Text(email, style: TextStyle(fontSize: 16.0)),
                      ),
                      new ListTile(
                        title: new Text("Role"),
                        trailing: new Text(role, style: TextStyle(fontSize: 16.0)),
                      ),
                      new ListTile(
                        title: new Text("Chaperone Group"),
                        trailing: new Text(chapGroupID, style: TextStyle(fontSize: 16.0)),
                      ),
                      new ListTile(
                        title: new Text("User ID"),
                        trailing: new Text(userID, style: TextStyle(fontSize: 14.0)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          new Padding(padding: EdgeInsets.all(8.0)),
          new Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(16.0),
                  child: new Text("General", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                ),
                new ListTile(
                  title: new Text("About"),
                  trailing: new Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  onTap: () {
                    router.navigateTo(context, '/aboutPage', transition: TransitionType.native);
                  },
                ),
                new Divider(height: 0.0, color: Colors.blue),
                new ListTile(
                  title: new Text("Help"),
                  trailing: new Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  onTap: () {
                    router.navigateTo(context, '/helpPage', transition: TransitionType.native);
                  },
                ),
                new Divider(height: 0.0, color: Colors.blue),
                new ListTile(
                  title: new Text("Legal"),
                  trailing: new Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  onTap: () {
                    router.navigateTo(context, '/legalPage', transition: TransitionType.native);
                  },
                ),
                new Divider(height: 0.0, color: Colors.blue),
                new ListTile(
                  title: new Text("\nDelete Account\n", style: TextStyle(color: Colors.red),),
                  subtitle: new Text("Deleting your VC DECA Account will remove all the data linked to your account as well. You will be required to create a new account in order to sign in again.\n", style: TextStyle(fontSize: 12.0)),
                  onTap: deleteAccountBottomSheet,
                )
              ],
            ),
          ),
          new Padding(padding: EdgeInsets.all(8.0)),
          new Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(16.0),
                  child: new Text("Preferences", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                ),
                new ListTile(
                  title: new Text("Push Notifications"),
                  trailing: new Switch(
                    value: true,
                    activeColor: Colors.blue,
                    onChanged: (bool isOn) {},
                  ),
                ),
                new Divider(height: 0.0, color: Colors.blue),
                new SwitchListTile(
                  title: new Text("Dark Mode"),
                  subtitle: new Text("Coming Soon!"),
                  value: darkMode,
                  activeColor: Colors.blue,
                  onChanged: (bool onChange) {},
                ),
              ],
            ),
          ),
          new Padding(padding: EdgeInsets.all(8.0)),
          new Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(16.0),
                  child: new Text("Feedback", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                ),
                new ListTile(
                  title: new Text("Provide Feedback"),
                  trailing: new Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  onTap: () {},
                ),
                new Divider(height: 0.0, color: Colors.blue),
                new ListTile(
                  title: new Text("Report a Bug"),
                  trailing: new Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  onTap: () {
                    router.navigateTo(context, '/bugReport', transition: TransitionType.native);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
