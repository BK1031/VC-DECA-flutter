import 'package:firebase_database/firebase_database.dart';

class EventEntry {
  String eventShort;
  String eventName;
  String eventBody;

  EventEntry(this.eventShort, this.eventName, this.eventBody);

  EventEntry.fromSnapshot(DataSnapshot snapshot)
      : eventShort = snapshot.key,
        eventName = snapshot.value["name"].toString(),
        eventBody = snapshot.value["body"].toString();
}