import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class EventClusterPage extends StatefulWidget {
  @override
  _EventClusterPageState createState() => _EventClusterPageState();
}

class _EventClusterPageState extends State<EventClusterPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  List<String> clusterList = new List();

  _EventClusterPageState() {
    databaseRef.child("events").child(selectedType).onChildAdded.listen((Event event) {
      setState(() {
        clusterList.add(event.snapshot.key);
      });
    });
  }

  Widget getLeadingPic(String name) {
    String imagePath = "";
    if (name == "Business Management") {
      imagePath = 'images/business.png';
    }
    else if (name == "Entrepreneurship") {
      imagePath = 'images/entrepreneurship.png';
    }
    else if (name == "Finance") {
      imagePath = 'images/finance.png';
    }
    else if (name == "Hospitality + Tourism") {
      imagePath = 'images/hospitality.png';
    }
    else if (name == "Marketing") {
      imagePath = 'images/marketing.png';
    }
    else if (name == "Personal Financial Literacy") {
      imagePath = 'images/personal-finance.png';
    }
    return Image.asset(
      imagePath,
      height: 35.0,
    );
  }

  void getCategoryColor(String name) {
    if (name == "Business Management") {
      eventColor = Color(0xFFfcc414);
      print("YELLOW");
    }
    else if (name == "Entrepreneurship") {
      eventColor = Color(0xFF818285);
      print("GREY");
    }
    else if (name == "Finance") {
      eventColor = Color(0xFF049e4d);
      print("GREEN");
    }
    else if (name == "Hospitality + Tourism") {
      eventColor = Color(0xFF046faf);
      print("INDIGO");
    }
    else if (name == "Marketing") {
      eventColor = Color(0xFFe4241c);
      print("RED");
    }
    else if (name == "Personal Financial Literacy") {
      eventColor = Color(0xFF7cc242);
      print("LT GREEN");
    }
    else {
      eventColor = mainColor;
      print("COLOR NOT FOUND");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("$selectedType Events"),
      ),
      backgroundColor: currBackgroundColor,
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new Text("Select an event cluster below."),
            new Padding(padding: EdgeInsets.only(bottom: 8.0)),
            new Expanded(
              child: new ListView.builder(
                itemCount: clusterList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: new Card(
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      child: new ListTile(
                        onTap: () {
                          selectedCluster = clusterList[index];
                          print(selectedCluster);
                          getCategoryColor(clusterList[index]);
                          router.navigateTo(context, '/event/cluster/event', transition: TransitionType.native);
                        },
                        leading: getLeadingPic(clusterList[index]),
                        title: new Text(
                          clusterList[index],
                          style: TextStyle(
                            fontFamily: "Product Sans",
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: mainColor,),
                      ),
                    )
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
