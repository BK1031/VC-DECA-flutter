import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

final router = Router();

double appVersion = 1.0;

String name = "";
String email = "";
String userID = "";
String chapGroupID = "Not in a Group";

bool darkMode = false;

String role = "Member";

String appStatus = "";

String selectedAlert = "";
String selectedYear = "Please select a conference";
String selectedCategory = "";
String selectedEvent = "";

// Body Colors
Color primaryColor = Colors.white;
Color primaryAccent = null;

// Text Colors
Color primaryTextColor = Colors.black;
Color secondaryTextColor = Colors.grey;