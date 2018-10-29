import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:vc_deca/bug_report.dart';
import 'package:vc_deca/network_check_again.dart';
import 'package:vc_deca/user_info.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca/alert_view.dart';
import 'package:vc_deca/chaperone_chat.dart';
import 'package:vc_deca/event_category.dart';
import 'package:vc_deca/event_view.dart';
import 'package:vc_deca/global_chat.dart';
import 'package:vc_deca/login.dart';
import 'package:vc_deca/network_checker.dart';
import 'package:vc_deca/officer_chat.dart';
import 'package:vc_deca/onboarding_page.dart';
import 'package:vc_deca/register_page.dart';
import 'package:vc_deca/auth_checker.dart';
import 'package:vc_deca/tab_bar_controller.dart';
import 'package:fluro/fluro.dart';

void main() {
  runApp(new MaterialApp(
    title: "VC DECA",
    home: ConnectionChecker(),
    onGenerateRoute: router.generator,
    debugShowCheckedModeBanner: false,
  ));
}