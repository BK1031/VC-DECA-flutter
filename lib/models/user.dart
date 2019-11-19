import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String appVersion;
  String chapGroup;
  String chatColor;
  bool darkMode;
  String deviceName;
  String email;
  String fcmToken;
  String mentorGroup;
  String name;
  String platform;
  String profilePicUrl;
  String role;
  bool staticLocation;
  String title;

  User.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        appVersion = snapshot.value["appVersion"].toString(),
        chapGroup = snapshot.value["chapGroup"].toString(),
        chatColor = snapshot.value["chatColor"].toString(),
        darkMode = snapshot.value["darkMode"],
        deviceName = snapshot.value["deviceName"].toString(),
        email = snapshot.value["email"].toString(),
        fcmToken = snapshot.value["fcmToken"].toString(),
        mentorGroup = snapshot.value["mentorGroup"].toString(),
        name = snapshot.value["name"].toString(),
        platform = snapshot.value["platform"].toString(),
        profilePicUrl = snapshot.value["profilePicUrl"].toString(),
        role = snapshot.value["role"].toString(),
        staticLocation = snapshot.value["staticLocation"],
        title = snapshot.value["title"].toString();
}