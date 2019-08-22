import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/models/event_entry.dart';

import 'models/announcement.dart';

String name = "";
String email = "";
String userID = "";
String chapGroupID = "Not in a Group";
String mentorGroupID = "Not in a Group";

String profilePic = "https://firebasestorage.googleapis.com/v0/b/vc-deca.appspot.com/o/default.png?alt=media&token=a38584fb-c774-4f75-99ab-71b120c87df1";

bool notifications = true;
bool chatNotifications = true;

String role = "Member";
String title = "Member";
List<String> userPerms = new List();

bool staticLocation = false;

Announcement selectedAnnouncement;

String selectedType = "";
String selectedCluster = "";
EventEntry selectedEvent;

String selectedAgenda = "";

String selectedMessage = "";
String selectedChat = "";
String chatTitle = "General";
String customChatColor = "";