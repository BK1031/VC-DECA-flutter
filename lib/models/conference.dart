import 'package:firebase_database/firebase_database.dart';

class Conference {
  String shortName;
  String fullName;
  String body;
  String imageUrl;
  String mapUrl;
  String location;
  String address;
  double lat;
  double long;

  Conference(this.shortName, this.fullName, this.body, this.imageUrl,
      this.mapUrl, this.location, this.address, this.lat, this.long);

  Conference.fromJson(Map<String, dynamic> json, String key)
  : shortName = key,
    fullName = json["full"],
    body = json["body"],
    imageUrl = json["imageUrl"],
    mapUrl = json["mapUrl"],
    location = json["location"],
    address = json["address"],
    lat = json["lat"],
    long = json["long"];

}
