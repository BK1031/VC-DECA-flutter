import 'package:firebase_database/firebase_database.dart';

class EventEntry {
  String eventShort;
  String eventName;
  String eventBody;
  String participants;

  EventEntry(this.eventShort, this.eventName, this.eventBody, this.participants);

  EventEntry.fromSnapshot(DataSnapshot snapshot)
      : eventShort = snapshot.key,
        eventName = snapshot.value["name"].toString(),
        eventBody = snapshot.value["desc"].toString(),
        participants = snapshot.value["participants"].toString();

  @override
  String toString() {
    return "$eventName [$eventShort]";
  }

}