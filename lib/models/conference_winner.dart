import 'package:firebase_database/firebase_database.dart';

class ConferenceWinner {
  String key;
  String name;
  String event;
  String award;

  ConferenceWinner(this.name, this.event, this.award);

  ConferenceWinner.fromSnaphost(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["name"],
        event = snapshot.value["event"],
        award = snapshot.value["award"];
}