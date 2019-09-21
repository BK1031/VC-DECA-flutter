import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StockDetailsPage extends StatefulWidget {
  @override
  _StockDetailsPageState createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: eventColor,
          title: new Text("SMG"),
          elevation: 0.0,
        ),
        backgroundColor: currBackgroundColor,
        body: new Stack(
          children: <Widget>[
            new Container(
              color: eventColor,
              height: 100.0,
            ),
            new Container(
              child: new SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Hero(
                      tag: "${selectedEvent.eventName}-card",
                      child: new Card(
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: currCardColor,
                        child: new Container(
                          padding: EdgeInsets.all(16.0),
                          child: new Column(
                            children: <Widget>[
                              new Text(
                                  selectedEvent.eventName,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)
                              ),
                              new Container(
                                width: double.infinity,
                                height: 100.0,
                                child: new Row(
                                  children: <Widget>[
                                    new Expanded(
                                      flex: 3,
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Text(
                                            "1-3",
                                            style: TextStyle(fontSize: 35.0),
                                          ),
                                          new Text(
                                            "Participants",
                                            style: TextStyle(fontSize: 15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                    new Expanded(
                                      flex: 3,
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Text(
                                            "10",
                                            style: TextStyle(fontSize: 35.0),
                                          ),
                                          new Text(
                                            "Pages",
                                            style: TextStyle(fontSize: 15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                    new Expanded(
                                      flex: 3,
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Text(
                                            "15",
                                            style: TextStyle(fontSize: 35.0),
                                          ),
                                          new Text(
                                            "Minutes",
                                            style: TextStyle(fontSize: 15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new Text(
                                selectedEvent.eventBody,
                                style: TextStyle(fontSize: 15.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(4.0)),
                    new Card(
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      child: new Container(
                        padding: EdgeInsets.all(16.0),
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              width: double.infinity,
                              height: 100.0,
                              child: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    flex: 3,
                                    child: new GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => new Scaffold(
                                            appBar: AppBar(
                                              backgroundColor: eventColor,
                                              title: new Text("${selectedEvent.eventShort} Guidelines"),
                                            ),
                                            backgroundColor: currBackgroundColor,
                                            body: new WebView(
                                              initialUrl: "https://www.deca.org/wp-content/uploads/2019/07/HS_SMG_Guidelines.pdf",
                                              javascriptMode: JavascriptMode.unrestricted,
                                            ),
                                          )),
                                        );
                                      },
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Icon(Icons.format_list_bulleted, size: 50.0,),
                                          new Text(
                                            "Guidelines",
                                            style: TextStyle(fontSize: 15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                    flex: 3,
                                    child: new GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => new Scaffold(
                                            appBar: AppBar(
                                              backgroundColor: eventColor,
                                              title: new Text("${selectedEvent.eventShort} Sample Event"),
                                            ),
                                            backgroundColor: currBackgroundColor,
                                            body: new WebView(
                                              initialUrl: "https://www.deca.org/wp-content/uploads/2019/07/DECA_Sample_SMG.pdf",
                                              javascriptMode: JavascriptMode.unrestricted,
                                            ),
                                          )),
                                        );
                                      },
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Icon(Icons.library_books, size: 50.0,),
                                          new Text(
                                            "Sample Event",
                                            style: TextStyle(fontSize: 15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                    flex: 3,
                                    child: new GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => new Scaffold(
                                            appBar: AppBar(
                                              backgroundColor: eventColor,
                                              title: new Text("${selectedEvent.eventShort} Penalty Points"),
                                            ),
                                            backgroundColor: currBackgroundColor,
                                            body: new WebView(
                                              initialUrl: "https://www.deca.org/wp-content/uploads/2018/07/Penalty-Point-Checklist.pdf",
                                              javascriptMode: JavascriptMode.unrestricted,
                                            ),
                                          )),
                                        );
                                      },
                                      child: new Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new Icon(Icons.close, size: 50.0,),
                                          new Text(
                                            "Penalty Points",
                                            style: TextStyle(fontSize: 15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(4.0)),
                    new Card(
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                      color: currCardColor,
                      child: new Container(
                        width: double.infinity,
                        child: new FlatButton(
                          child: new Text("COMPETITIVE EVENTS SITE"),
                          textColor: eventColor,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => new Scaffold(
                                backgroundColor: currBackgroundColor,
                                body: new WebView(
                                  initialUrl: "https://www.deca.org/high-school-programs/high-school-competitive-events/",
                                  javascriptMode: JavascriptMode.unrestricted,
                                ),
                              )),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}