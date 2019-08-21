import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/user_info.dart';

class WrittenDetailsPage extends StatefulWidget {
  @override
  _WrittenDetailsPageState createState() => _WrittenDetailsPageState();
}

class _WrittenDetailsPageState extends State<WrittenDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(selectedEvent.eventName),
      ),
    );
  }
}
