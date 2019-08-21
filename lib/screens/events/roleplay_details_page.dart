import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vc_deca_flutter/user_info.dart';

class RoleplayDetailsPage extends StatefulWidget {
  @override
  _RoleplayDetailsPageState createState() => _RoleplayDetailsPageState();
}

class _RoleplayDetailsPageState extends State<RoleplayDetailsPage> {

  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(selectedEvent.eventName),
      ),
    );
  }
}
