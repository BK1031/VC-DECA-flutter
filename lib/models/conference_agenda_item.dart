import 'package:firebase_database/firebase_database.dart';

class ConferenceAgendaItem {
  String key;
  String title;
  String desc;
  String date;
  String time;
  String endTime;
  String location;

  ConferenceAgendaItem(this.title, this.desc, this.date, this.time,
      this.endTime, this.location);

  ConferenceAgendaItem.fromJson(Map<String, dynamic> json, String key)
      : key = key,
        title = json["title"],
        desc = json["desc"],
        date = json["date"],
        time = json["time"],
        endTime = json["endTime"],
        location = json["location"];
}