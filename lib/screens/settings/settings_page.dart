import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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

  void handleSignOut() async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(context: context, builder: (BuildContext context) {
        return new CupertinoActionSheet(
//          title: new Text("Sign out"),
          message: new Text("Are you sure you want to sign out?"),
          actions: <Widget>[
             new CupertinoActionSheetAction(
               child: new Text("Sign out"),
               isDestructiveAction: true,
               onPressed: () async {
                 await AuthFunctions.signOut().then((response) {
                   if (response) {
                     router.navigateTo(context, '/onboarding', replace: true, clearStack: true, transition: TransitionType.fadeIn);
                   }
                   else {
                     // TODO: Add error alert
                   }
                 });
               },
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
                title: new Text('Are you sure you want to sign out?'),
              ),
              new ListTile(
                leading: new Icon(Icons.check),
                title: new Text('Yes, sign me out!'),
                onTap: () async {
                  await AuthFunctions.signOut().then((response) {
                    if (response) {
                      router.navigateTo(context, '/onboarding', replace: true, clearStack: true, transition: TransitionType.fadeIn);
                    }
                    else {
                      // TODO: Add error alert
                    }
                  });
                },
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
                    title: new Text("Email", style: TextStyle(fontFamily: "Product Sans", color: currTextColor),),
                    trailing: new Text(email, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans", color: currTextColor)),
                  ),
                  new ListTile(
                    title: new Text("Role", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                    trailing: new Text(role, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans", color: currTextColor)),
                  ),
                  new ListTile(
                    title: new Text("Mentor Group", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                    trailing: new Text(mentorGroupID, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans", color: currTextColor)),
                  ),
                  new ListTile(
                    title: new Text("Chaperone Group", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                    trailing: new Text(chapGroupID, style: TextStyle(fontSize: 16.0, fontFamily: "Product Sans", color: currTextColor)),
                  ),
                  new ListTile(
                    title: new Text("User ID", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                    trailing: new Text(userID, style: TextStyle(fontSize: 14.0, fontFamily: "Product Sans", color: currTextColor)),
                  ),
                  new ListTile(
                    title: new Text("Update Profile", style: TextStyle(fontFamily: "Product Sans", color: mainColor), textAlign: TextAlign.center,),
                    onTap: () {
                      router.navigateTo(context, '/settings/update-profile', transition: TransitionType.nativeModal);
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
                    title: new Text("About", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                    onTap: () {
                      router.navigateTo(context, '/settings/about', transition: TransitionType.native);
                    },
                  ),
                  new ListTile(
                    title: new Text("Help", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                    onTap: () async {
                      const url = 'https://github.com/BK1031/VC-DECA-flutter/wiki/Help';
                      if (await canLaunch(url)) {
                      await launch(url);
                      } else {
                      throw 'Could not launch $url';
                      }
                    },
                  ),
                  new ListTile(
                      title: new Text("Legal", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
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
                    onTap: handleSignOut,
                  ),
                  new ListTile(
                    title: new Text("\nDelete Account\n", style: TextStyle(color: Colors.red, fontFamily: "Product Sans"),),
                    subtitle: new Text("Deleting your VC DECA Account will remove all the data linked to your account as well. You will be required to create a new account in order to sign in again.\n", style: TextStyle(fontSize: 12.0, fontFamily: "Product Sans", color: Colors.grey)),
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
                    title: new Text("Push Notifications", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
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
                    title: new Text("Chat Notifications", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                    value: chatNotifications,
                    onChanged: (bool value) {
                      setState(() {
                        chatNotifications = value;
                      });
                    },
                  ),
                  new Visibility(
                    visible: (userPerms.contains('DEV') || userPerms.contains('ADMIN')),
                    child: new SwitchListTile.adaptive(
                      activeColor: mainColor,
                      activeTrackColor: mainColor,
                      title: new Text("Dark Mode", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                      value: darkMode,
                      onChanged: (bool value) {
                        // Toggle Dark Mode
                        setState(() {
                          darkMode = value;
                          if (darkMode) {
                            currTextColor = darkTextColor;
                            currBackgroundColor = darkBackgroundColor;
                            currCardColor = darkCardColor;
                            currDividerColor = darkDividerColor;
                          }
                          else {
                            currTextColor = lightTextColor;
                            currBackgroundColor = lightBackgroundColor;
                            currCardColor = lightCardColor;
                            currDividerColor = lightDividerColor;
                          }
                          FirebaseDatabase.instance.reference().child("users").child(userID).update({"darkMode": darkMode});
                        });
                      },
                    ),
                  ),
                  new AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: darkMode ? 60 : 0,
                    child: new Visibility(
                      visible: darkMode,
                      child: new SwitchListTile.adaptive(
                        activeColor: mainColor,
                        activeTrackColor: mainColor,
                        title: new Text("Dark AppBar", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                        value: darkAppBar,
                        onChanged: (bool value) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          // Toggle Dark Mode
                          await prefs.setBool('darkAppBar', value);
                          setState(() {
                            darkAppBar = value;
                          });
                        },
                      ),
                    ),
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
                    child: new Text("Feedback".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                  ),
                  new ListTile(
                    title: new Text("Provide Feedback", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                    onTap: () async {
                      const url = 'https://github.com/BK1031/VC-DECA-flutter/issues';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                  new ListTile(
                    title: new Text("Report a Bug", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                    trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                    onTap: () async {
                      const url = 'https://github.com/BK1031/VC-DECA-flutter/issues';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                ],
              ),
            ),
            new Visibility(
              visible: (userPerms.contains('DEV') || userPerms.contains('ADMIN')),
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
                          leading: new Icon(Icons.developer_mode, color: darkMode ? Colors.grey : Colors.black54,),
                          title: new Text("Test Firebase Upload", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
                          onTap: () {
                            FirebaseDatabase.instance.reference().child("testing").push().set("$name - $role");
                          },
                        ),
                        new ListTile(
                          leading: new Icon(Icons.event_note, color: darkMode ? Colors.grey : Colors.black54),
                          title: new Text("Add New Conference", style: TextStyle(fontFamily: "Product Sans", color: currTextColor)),
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
