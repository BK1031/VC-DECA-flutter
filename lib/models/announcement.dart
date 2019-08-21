import 'package:firebase_database/firebase_database.dart';

class Announcement {
  String key;
  String title;
  String date;
  String body;

  Announcement(this.title, this.date, this.body);

  Announcement.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value["title"].toString(),
        date = snapshot.value["date"].toString(),
        body = snapshot.value["body"].toString();

}