import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vc_deca_flutter/screens/auth/auth_functions.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import '../../user_info.dart';
import 'package:fluro/fluro.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool _devVisible = false;

  _SettingsPageState() {
    if (userPerms.contains("DEV")) {
      _devVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: currBackgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            new Card(
              elevation: 6.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              child: new Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(top: 16.0),
                    child: new Text(name.toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                  ),
                  new ListTile(
                    title: new Text("Email", style: TextStyle(fontFamily: "Product Sans"),),
                    trailing: new Text(email, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans")),
                  ),
                  new ListTile(
                    title: new Text("Role", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Text(role, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans")),
                  ),
                  new ListTile(
                    title: new Text("Chaperone Group", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Text(chapGroupID, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans")),
                  ),
                  new ListTile(
                    title: new Text("User ID", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Text(userID, style: TextStyle(fontSize: 14.0, fontFamily: "Product Sans")),
                  ),
                  new ListTile(
                    title: new Text("Update Profile", style: TextStyle(fontFamily: "Product Sans", color: mainColor), textAlign: TextAlign.center,),
                    onTap: () {
                      router.navigateTo(context, '/profilePic', transition: TransitionType.nativeModal);
                    },
                  )
                ],
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Card(
              elevation: 6.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              child: Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(top: 16.0),
                    child: new Text("General".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                  ),
                  new ListTile(
                    title: new Text("About", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                    onTap: () {
                      router.navigateTo(context, '/settings/about', transition: TransitionType.native);
                    },
                  ),
                  new ListTile(
                    title: new Text("Help", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                    onTap: () {
                    },
                  ),
                  new ListTile(
                      title: new Text("Legal", style: TextStyle(fontFamily: "Product Sans",)),
                      trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                      onTap: () {
                        showLicensePage(
                            context: context,
                            applicationVersion: appFull + appStatus,
                            applicationName: "VC DECA App",
                            applicationLegalese: appLegal,
                            applicationIcon: new Image.asset(
                              'images/logo_blue_trans',
                              height: 35.0,
                            )
                        );
                      }
                  ),
                  new ListTile(
                    title: new Text("Sign Out", style: TextStyle(color: Colors.red, fontFamily: "Product Sans"),),
                    onTap: () async {
                      await AuthFunctions.signOut().then((response) {
                        if (response) {
                          router.navigateTo(context, '/onboarding', );
                        }
                        else {

                        }
                      });
                    },
                  ),
                  new ListTile(
                    title: new Text("\nDelete Account\n", style: TextStyle(color: Colors.red, fontFamily: "Product Sans"),),
                    subtitle: new Text("Deleting your VC DECA Account will remove all the data linked to your account as well. You will be required to create a new account in order to sign in again.\n", style: TextStyle(fontSize: 12.0, fontFamily: "Product Sans")),
                  )
                ],
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Card(
              elevation: 6.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              child: Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(top: 16.0),
                    child: new Text("Preferences".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                  ),
                  new SwitchListTile.adaptive(
                    activeColor: mainColor,
                    activeTrackColor: mainColor,
                    title: new Text("Push Notifications", style: TextStyle(fontFamily: "Product Sans",)),
                    value: notifications,
                    onChanged: (bool value) {
                      setState(() {
                        notifications = value;
                      });
                    },
                  ),
                  new SwitchListTile.adaptive(
                    activeColor: mainColor,
                    activeTrackColor: mainColor,
                    title: new Text("Chat Notifications", style: TextStyle(fontFamily: "Product Sans",)),
                    value: chatNotifications,
                    onChanged: (bool value) {
                      setState(() {
                        chatNotifications = value;
                      });
                    },
                  ),
                  new SwitchListTile.adaptive(
                    activeColor: mainColor,
                    activeTrackColor: mainColor,
                    title: new Text("Dark Mode", style: TextStyle(fontFamily: "Product Sans",)),
                    value: darkMode,
                    onChanged: (bool value) {
                      setState(() {
                        darkMode = value;
                        FirebaseDatabase.instance.reference().child("users").child(userID).update({"darkMode": darkMode});
                      });
                    },
                  ),
                ],
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Card(
              elevation: 6.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              child: Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(top: 16.0),
                    child: new Text("Preferences".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                  ),
                  new ListTile(
                    title: new Text("Provide Feedback", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                    onTap: () {
                    },
                  ),
                  new ListTile(
                    title: new Text("Report a Bug", style: TextStyle(fontFamily: "Product Sans",)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                    onTap: () {
                    },
                  ),
                ],
              ),
            ),
            new Visibility(
              visible: _devVisible,
              child: new Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.all(4.0)),
                  new Card(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    color: currCardColor,
                    child: Column(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.only(top: 16.0),
                          child: new Text("developer".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                        ),
                        new ListTile(
                          leading: new Icon(Icons.developer_mode),
                          title: new Text("Test Firebase Upload", style: TextStyle(fontFamily: "Product Sans",)),
                          onTap: () {
                            FirebaseDatabase.instance.reference().child("testing").push().set("$name - $role");
                          },
                        ),
                        new ListTile(
                          leading: new Icon(Icons.event_note),
                          title: new Text("Add New Conference", style: TextStyle(fontFamily: "Product Sans",)),
                          onTap: () {
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
