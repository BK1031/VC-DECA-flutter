import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vc_deca_flutter/screens/conferences/conference_winners_page.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

import 'conference_media_page.dart';
import 'conference_schedule_page.dart';

class ConferenceViewPage extends StatefulWidget {
  @override
  _ConferenceViewPageState createState() => _ConferenceViewPageState();
}

class _ConferenceViewPageState extends State<ConferenceViewPage> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: "OVERVIEW",
              ),
              Tab(
                text: "SCHEDULE",
              ),
              Tab(
                text: "WINNERS",
              ),
              Tab(
                  text: "MEDIA"
              ),
            ],
            indicatorColor: currBackgroundColor,
          ),
          title: new Text(selectedConference.shortName.split(" ")[1]),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            new ConferenceOverview(),
            new ConferenceSchedulePage(),
            new ConferenceWinnersPage(),
            new ConferenceMediaPage()
          ],
        ),
      ),
    );
  }
}

class ConferenceOverview extends StatefulWidget {
  @override
  _ConferenceOverviewState createState() => _ConferenceOverviewState();
}

class _ConferenceOverviewState extends State<ConferenceOverview> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  String full = "";
  String desc = "";
  String date = "";
  String location = "";
  String address = "";
  double lat = 0.0;
  double long = 0.0;

  _ConferenceOverviewState() {
    databaseRef.child("conferences").child(selectedConference.shortName).once().then((DataSnapshot snapshot) {
      var conferenceDetails = snapshot.value;
      setState(() {
        full = conferenceDetails["full"];
        desc = conferenceDetails["desc"];
        location = conferenceDetails["location"];
        date = conferenceDetails["date"];
        address = conferenceDetails["address"];
        lat = conferenceDetails["lat"];
        long = conferenceDetails["long"];
      });
    });
  }

  void missingDataDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Bruh moment"),
          content: new Text(
            "It looks like there was an error retrieving this file. Please check back later.",
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

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                full,
                style: TextStyle(
                  fontFamily: "Product Sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.left,
              ),
              new Padding(padding: EdgeInsets.all(4.0)),
              new Text(
                date,
                style: TextStyle(
                  fontFamily: "Product Sans",
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                  color: mainColor,
                  fontSize: 18.0,
                ),
              ),
              new Padding(padding: EdgeInsets.all(4.0)),
              new Text(
                desc,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                  fontFamily: "Product Sans",
                ),
              ),
              new Divider(
                color: mainColor,
                height: 20.0,
              ),
              new Text(
                "Conference Location:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Product Sans",
                  fontSize: 18.0,
                ),
              ),
              new ListTile(
                title: Text(location, style: TextStyle(fontFamily: "Product Sans"),),
                subtitle: Text(address, style: TextStyle(fontFamily: "Product Sans"),),
                onTap: () {
                  databaseRef.child("conferences").child(selectedConference.shortName).child("mapUrl").once().then((DataSnapshot snapshot) {
                    if (snapshot.value != null) {
                      router.navigateTo(context, '/mapUrl', transition: TransitionType.native);
                    }
                    else {
                      missingDataDialog();
                    }
                  });
                },
              ),
              new Divider(height: 20.0, color: mainColor),
              new Text(
                "Conference Resources:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Product Sans",
                  fontSize: 18.0,
                ),
              ),
              new ListTile(
                title: new Text("Hotel Map", style: TextStyle(fontFamily: "Product Sans"),),
                onTap: () {
                  databaseRef.child("conferences").child(selectedConference.shortName).child("hotelMap").once().then((DataSnapshot snapshot) {
                    if (snapshot.value != null) {
                      router.navigateTo(context, '/hotelMap', transition: TransitionType.native);
                    }
                    else {
                      missingDataDialog();
                    }
                  });
                },
                trailing: new Icon(
                  Icons.arrow_forward_ios,
                  color: mainColor,
                ),
              ),
//            new Divider(height: 0.0, color: mainColor),
              new ListTile(
                title: new Text("Announcements", style: TextStyle(fontFamily: "Product Sans"),),
                onTap: () {
                  databaseRef.child("conferences").child(selectedConference.shortName).child("alerts").once().then((DataSnapshot snapshot) {
                    if (snapshot.value != null) {
                      router.navigateTo(context, '/conferenceAnnouncements', transition: TransitionType.native);
                    }
                    else {
                      missingDataDialog();
                    }
                  });
                },
                trailing: new Icon(
                  Icons.arrow_forward_ios,
                  color: mainColor,
                ),
              ),
              new ListTile(
                title: new Text("Competitive Event Schedule", style: TextStyle(fontFamily: "Product Sans"),),
                onTap: () {
                  databaseRef.child("conferences").child(selectedConference.shortName).child("eventsUrl").once().then((DataSnapshot snapshot) {
                    if (snapshot.value != null) {
                      var url = snapshot.value;
                      launch(url);
                    }
                    else {
                      missingDataDialog();
                    }
                  });
//                router.navigateTo(context, '/compEventSite', transition: TransitionType.native);
                },
                trailing: new Icon(
                  Icons.arrow_forward_ios,
                  color: mainColor,
                ),
              ),
              new ListTile(
                title: new Text("Check out the official ${selectedConference.shortName.split(" ")[1]} website", style: TextStyle(fontFamily: "Product Sans", color: mainColor), textAlign: TextAlign.center,),
                onTap: () {
                  router.navigateTo(context, '/conferenceSite', transition: TransitionType.native);
                },
              )
            ],
          ),
        )
    );
  }
}

class HotelMapView extends StatefulWidget {
  @override
  _HotelMapViewState createState() => _HotelMapViewState();
}

class _HotelMapViewState extends State<HotelMapView> {
  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  String url;

  _HotelMapViewState() {
    databaseRef.child("conferences").child(selectedConference.shortName).child("hotelMap").once().then((DataSnapshot snapshot) {
      setState(() {
        url = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("Hotel Map"),
        centerTitle: true,
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold)
        ),
      ),
      url: url,
      withZoom: true,
    );
  }
}

class ConferenceAnnouncementsPage extends StatefulWidget {
  @override
  _ConferenceAnnouncementsPageState createState() => _ConferenceAnnouncementsPageState();
}

class _ConferenceAnnouncementsPageState extends State<ConferenceAnnouncementsPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  String url;

  _ConferenceAnnouncementsPageState() {
    databaseRef.child("conferences").child(selectedConference.shortName).child("alerts").once().then((DataSnapshot snapshot) {
      setState(() {
        url = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("Announcements"),
        centerTitle: true,
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold)
        ),
      ),
      url: url,
      withZoom: true,
    );
  }
}

class MapLocationView extends StatefulWidget {
  @override
  _MapLocationViewState createState() => _MapLocationViewState();
}

class _MapLocationViewState extends State<MapLocationView> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  String url;

  _MapLocationViewState() {
    databaseRef.child("conferences").child(selectedConference.shortName).child("mapUrl").once().then((DataSnapshot snapshot) {
      setState(() {
        url = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("Map View"),
        centerTitle: true,
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold)
        ),
      ),
      url: url,
      withZoom: true,
    );
  }
}

class ConferenceSitePage extends StatefulWidget {
  @override
  _ConferenceSitePageState createState() => _ConferenceSitePageState();
}

class _ConferenceSitePageState extends State<ConferenceSitePage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  String url;

  _ConferenceSitePageState() {
    databaseRef.child("conferences").child(selectedConference.shortName).child("site").once().then((DataSnapshot snapshot) {
      setState(() {
        url = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("${selectedConference.shortName.split(" ")[1]} Site"),
        centerTitle: true,
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold)
        ),
      ),
      url: url,
      withZoom: true,
    );
  }
}

class CompetitiveEventsPage extends StatefulWidget {
  @override
  _CompetitiveEventsPageState createState() => _CompetitiveEventsPageState();
}

class _CompetitiveEventsPageState extends State<CompetitiveEventsPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  String url;

  _CompetitiveEventsPageState() {
    databaseRef.child("conferences").child(selectedConference.shortName).child("eventsUrl").once().then((DataSnapshot snapshot) {
      setState(() {
        url = snapshot.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("Events Schedule"),
        centerTitle: true,
        textTheme: TextTheme(
            title: TextStyle(
                fontFamily: "Product Sans",
                fontSize: 25.0,
                fontWeight: FontWeight.bold)
        ),
      ),
      url: url,
      withZoom: true,
      supportMultipleWindows: true,
    );
  }
}