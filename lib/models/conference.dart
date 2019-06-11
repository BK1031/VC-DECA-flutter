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

  Conference.fromSnapshot(DataSnapshot snapshot)
  : shortName = snapshot.key,
    fullName = snapshot.value["full"],
    body = snapshot.value["body"],
    imageUrl = snapshot.value["imageUrl"],
    mapUrl = snapshot.value["mapUrl"],
    location = snapshot.value["location"],
    address = snapshot.value["address"],
    lat = snapshot.value["lat"],
    long = snapshot.value["long"];

}
