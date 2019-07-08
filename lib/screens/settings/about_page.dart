import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String devicePlatform = "";
  String deviceName = "";

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      devicePlatform = "iOS";
    }
    else if (Platform.isAndroid) {
      devicePlatform = "Android";
    }
    deviceName = Platform.localHostname;
  }

  launchContributeUrl() async {
    const url = 'https://github.com/BK1031/VC-DECA-flutter';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchGuidelinesUrl() async {
    const url = 'https://github.com/BK1031/VC-DECA-flutter/wiki/contributing';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: new Text("About"),
        ),
        backgroundColor: currBackgroundColor,
        body: new SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                new Card(
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  color: currCardColor,
                  child: Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(top: 16.0),
                        child: new Text("device".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                      ),
                      new ListTile(
                        title: new Text("App Version", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Text("$appVersion$appStatus", style: TextStyle(fontFamily: "Product Sans", fontSize: 16.0)),
                      ),
                      new ListTile(
                        title: new Text("Device Name", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Text("$deviceName", style: TextStyle(fontFamily: "Product Sans", fontSize: 16.0)),
                      ),
                      new ListTile(
                        title: new Text("Platform", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Text("$devicePlatform", style: TextStyle(fontFamily: "Product Sans", fontSize: 16.0)),
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
                        child: new Text("credits".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                      ),
                      new ListTile(
                        title: new Text("Bharat Kathi", style: TextStyle(fontFamily: "Product Sans",)),
                        subtitle: new Text("App Development", style: TextStyle(fontFamily: "Product Sans",)),
                        onTap: () {
                          const url = 'https://www.instagram.com/bk1031_official';
                          launch(url);
                        },
                      ),
                      new ListTile(
                        title: new Text("Myron Chan", style: TextStyle(fontFamily: "Product Sans",)),
                        subtitle: new Text("App Design", style: TextStyle(fontFamily: "Product Sans",)),
                        onTap: () {
                          const url = 'https://www.instagram.com/myronchan_/';
                          launch(url);
                        },
                      ),
                      new ListTile(
                        title: new Text("Andrew Zhang", style: TextStyle(fontFamily: "Product Sans",)),
                        subtitle: new Text("Documentation", style: TextStyle(fontFamily: "Product Sans",)),
                        onTap: () {
                          const url = 'https://www.instagram.com/a.__.zhang/';
                          launch(url);
                        },
                      ),
                      new ListTile(
                        title: new Text("Kashyap Chaturvedula", style: TextStyle(fontFamily: "Product Sans",)),
                      ),
                      new ListTile(
                        subtitle: new Text("Beta Testers\n", style: TextStyle(fontFamily: "Product Sans",)),
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
                        child: new Text("contributing".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                      ),
                      new ListTile(
                        title: new Text("View on GitHub", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                        onTap: () {
                          launchContributeUrl();
                        },
                      ),
                      new ListTile(
                        title: new Text("Contributing Guidelines", style: TextStyle(fontFamily: "Product Sans",)),
                        trailing: new Icon(Icons.arrow_forward_ios, color: mainColor),
                        onTap: () {
                          launchGuidelinesUrl();
                        },
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(16.0)),
                new Text("© Equinox Initiative 2019", style: TextStyle(fontFamily: "Product Sans", color: Colors.grey),),
                new Image.asset(
                  'images/full_black_trans.png',
                  height: 120.0,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        )
    );
  }
}