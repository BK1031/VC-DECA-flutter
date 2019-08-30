import 'package:firebase_database/firebase_database.dart';

class Conference {
  String shortName;
  String fullName;
  String desc;
  String date;
  String imageUrl;
  String mapUrl;
  String hotelMapUrl;
  String eventsUrl;
  String alertsUrl;
  String siteUrl;
  String location;
  String address;
  double lat;
  double long;

  Conference(this.shortName, this.fullName, this.desc, this.date, this.imageUrl,
      this.mapUrl, this.hotelMapUrl, this.eventsUrl, this.siteUrl, this.location, this.address,
      this.lat, this.long);

  Conference.fromJson(Map<String, dynamic> json, String key)
  : shortName = key,
    fullName = json["full"],
    desc = json["desc"],
    date = json["date"],
    imageUrl = json["imageUrl"],
    mapUrl = json["mapUrl"],
    hotelMapUrl = json["hotelMap"],
    eventsUrl = json["eventsUrl"],
    siteUrl = json["site"],
    alertsUrl = json["alerts"],
    location = json["location"],
    address = json["address"],
    lat = json["lat"],
    long = json["long"];

}
