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

  Conference(this.shortName, this.fullName, this.desc, this.date, this.imageUrl,
      this.mapUrl, this.hotelMapUrl, this.eventsUrl, this.siteUrl, this.location, this.address);

  Conference.fromSnapshot(DataSnapshot snapshot)
  : shortName = snapshot.key,
    fullName = snapshot.value["full"],
    desc = snapshot.value["desc"],
    date = snapshot.value["date"],
    imageUrl = snapshot.value["imageUrl"],
    mapUrl = snapshot.value["mapUrl"],
    hotelMapUrl = snapshot.value["hotelMap"],
    eventsUrl = snapshot.value["eventsUrl"],
    siteUrl = snapshot.value["site"],
    alertsUrl = snapshot.value["alerts"],
    location = snapshot.value["location"],
    address = snapshot.value["address"];
}
