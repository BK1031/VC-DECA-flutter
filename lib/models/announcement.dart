import 'package:firebase_database/firebase_database.dart';

class Announcement {
  String key;
  String title;
  String author;
  String date;
  String body;

  Announcement(this.title, this.date, this.body);

  Announcement.fromJson(Map<String, dynamic> json, String key)
      : key = key,
        title = json["title"].toString(),
        author = json["author"].toString(),
        date = json["date"].toString(),
        body = json["body"].toString();

  @override
  String toString() {
    return "$title - $author - $body";
  }


}