import 'dart:io';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/screens/conferences/conference_winners_page.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
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

  void missingDataDialog() {
    // flutter defined function
    if (Platform.isIOS) {
      showCupertinoDialog(context: context, builder: (context) {
        return CupertinoAlertDialog(
          title: new Text("Bruh Moment"),
          content: new Text(
              '\nIt looks like this file may not have been added yet. Please check back later.'),
          actions: <Widget>[
            new CupertinoDialogAction(
              child: new Text("OK"),
              onPressed: () async {
                router.pop(context);
              },
            ),
          ],
        );
      });
    }
    else if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Bruh moment"),
            content: new Text(
              "It looks like this file may not have been added yet. Please check back later.",
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
                selectedConference.fullName,
                style: TextStyle(
                  fontFamily: "Product Sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.left,
              ),
              new Padding(padding: EdgeInsets.all(4.0)),
              new Text(
                selectedConference.date,
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
                selectedConference.desc,
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
                title: Text(selectedConference.location, style: TextStyle(fontFamily: "Product Sans"),),
                subtitle: Text(selectedConference.address, style: TextStyle(fontFamily: "Product Sans"),),
                onTap: () {
                  if (selectedConference.mapUrl != "") {
                    router.navigateTo(context, '/conference/details/location-map', transition: TransitionType.native);
                  }
                  else {
                    missingDataDialog();
                  }
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
                  if (selectedConference.hotelMapUrl != "") {
                    router.navigateTo(context, '/conference/details/hotel-map', transition: TransitionType.native);
                  }
                  else {
                    missingDataDialog();
                  }
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
                  if (selectedConference.alertsUrl != "") {
                    router.navigateTo(context, '/conference/details/announcements', transition: TransitionType.native);
                  }
                  else {
                    missingDataDialog();
                  }
                },
                trailing: new Icon(
                  Icons.arrow_forward_ios,
                  color: mainColor,
                ),
              ),
              new ListTile(
                title: new Text("Competitive Event Schedule", style: TextStyle(fontFamily: "Product Sans"),),
                onTap: () {
                  if (selectedConference.eventsUrl != "") {
                    router.navigateTo(context, '/conference/details/competitive-events', transition: TransitionType.native);
                  }
                  else {
                    missingDataDialog();
                  }
                },
                trailing: new Icon(
                  Icons.arrow_forward_ios,
                  color: mainColor,
                ),
              ),
              new ListTile(
                title: new Text("Check out the official ${selectedConference.shortName.split(" ")[1]} website", style: TextStyle(fontFamily: "Product Sans", color: mainColor), textAlign: TextAlign.center,),
                onTap: () {
                  if (selectedConference.siteUrl != "") {
                    router.navigateTo(context, '/conference/details/site', transition: TransitionType.native);
                  }
                  else {
                    missingDataDialog();
                  }
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

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("Hotel Map"),
        centerTitle: true,
      ),
      url: selectedConference.hotelMapUrl,
      withZoom: true,
    );
  }
}

class ConferenceAnnouncementsPage extends StatefulWidget {
  @override
  _ConferenceAnnouncementsPageState createState() => _ConferenceAnnouncementsPageState();
}

class _ConferenceAnnouncementsPageState extends State<ConferenceAnnouncementsPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("${selectedConference.shortName.split(" ")[1]} Announcements"),
      ),
      backgroundColor: currBackgroundColor,
      body: new WebView(
        initialUrl: selectedConference.alertsUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class MapLocationView extends StatefulWidget {
  @override
  _MapLocationViewState createState() => _MapLocationViewState();
}

class _MapLocationViewState extends State<MapLocationView> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("Map View"),
      ),
      backgroundColor: currBackgroundColor,
      body: new WebView(
        initialUrl: selectedConference.mapUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class ConferenceSitePage extends StatefulWidget {
  @override
  _ConferenceSitePageState createState() => _ConferenceSitePageState();
}

class _ConferenceSitePageState extends State<ConferenceSitePage> {

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("${selectedConference.shortName.split(" ")[1]} Site"),
        centerTitle: true,
      ),
      url: selectedConference.siteUrl,
      withZoom: true,
    );
  }
}

class CompetitiveEventsPage extends StatefulWidget {
  @override
  _CompetitiveEventsPageState createState() => _CompetitiveEventsPageState();
}

class _CompetitiveEventsPageState extends State<CompetitiveEventsPage> {

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: new Text("Events Schedule"),
        centerTitle: true,
      ),
      url: selectedConference.eventsUrl,
      withZoom: true,
      supportMultipleWindows: true,
    );
  }
}