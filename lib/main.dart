import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/screens/auth/auth_checker.dart';
import 'package:vc_deca_flutter/screens/auth/login_page.dart';
import 'package:vc_deca_flutter/screens/auth/register_page.dart';
import 'package:vc_deca_flutter/screens/chat/global_chat_page.dart';
import 'package:vc_deca_flutter/screens/conferences/conference_media_view_page.dart';
import 'package:vc_deca_flutter/screens/conferences/conference_view_page.dart';
import 'package:vc_deca_flutter/screens/events/event_cluster_page.dart';
import 'package:vc_deca_flutter/screens/events/event_selection_page.dart';
import 'package:vc_deca_flutter/screens/events/online_details_page.dart';
import 'package:vc_deca_flutter/screens/events/roleplay_details_page.dart';
import 'package:vc_deca_flutter/screens/events/smg_details_page.dart';
import 'package:vc_deca_flutter/screens/events/written_details_page.dart';
import 'package:vc_deca_flutter/screens/home/announcement_details_page.dart';
import 'package:vc_deca_flutter/screens/home/announcement_page.dart';
import 'package:vc_deca_flutter/screens/home/new_announcement_page.dart';
import 'package:vc_deca_flutter/screens/home/notification_manager_page.dart';
import 'package:vc_deca_flutter/screens/settings/about_page.dart';
import 'package:vc_deca_flutter/screens/settings/update_profile_page.dart';
import 'package:vc_deca_flutter/screens/startup/network_cheker.dart';
import 'package:vc_deca_flutter/screens/startup/onboarding_page.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:fluro/fluro.dart';
import 'package:vc_deca_flutter/tab_bar_controller.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  // STARTUP ROUTES
  router.define('/check-connection', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new NetworkChecker();
  }));
  router.define('/onboarding', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new OnboardingPage();
  }));

  // AUTH ROUTES
  router.define('/check-auth', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AuthChecker();
  }));
  router.define('/register', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new RegisterPage();
  }));
  router.define('/login', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  }));

  // HOME ROUTES
  router.define('/home', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TabBarController();
  }));
  router.define('/home/announcements', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AnnouncementPage();
  }));
  router.define('/home/announcements/new', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new NewAnnouncementPage();
  }));
  router.define('/home/announcements/details', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AnnouncementDetailsPage();
  }));
  router.define('/home/notification-manager', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new NotificationManagerPage();
  }));

  // CONFERENCE ROUTES
  router.define('/conference/details', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ConferenceViewPage();
  }));
  router.define('/conference/details/location-map', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new MapLocationView();
  }));
  router.define('/conference/details/hotel-map', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new HotelMapView();
  }));
  router.define('/conference/details/announcements', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ConferenceAnnouncementsPage();
  }));
  router.define('/conference/details/competitive-events', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new CompetitiveEventsPage();
  }));
  router.define('/conference/details/site', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ConferenceSitePage();
  }));
  router.define('/conference/details/media-view', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ConferenceMediaViewPage();
  }));

  // EVENT ROUTES
  router.define('/event/cluster', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new EventClusterPage();
  }));
  router.define('/event/cluster/event', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new EventSelectionPage();
  }));
  router.define('/event/cluster/event/roleplay-details', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new RoleplayDetailsPage();
  }));
  router.define('/event/cluster/event/written-details', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new WrittenDetailsPage();
  }));
  router.define('/event/cluster/event/online-details', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new OnlineDetailsPage();
  }));
  router.define('/event/cluster/event/smg-details', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new StockDetailsPage();
  }));

  // CHAT ROUTES
  router.define('/chat/global', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new GlobalChatPage();
  }));

  // SETTINGS ROUTES
  router.define('/settings/about', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AboutPage();
  }));
  router.define('/settings/update-profile', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new UpdateProfilePage();
  }));

  runApp(new MaterialApp(
    title: "VC DECA",
    home: NetworkChecker(),
    onGenerateRoute: router.generator,
    navigatorObservers: [routeObserver],
    debugShowCheckedModeBanner: false,
    theme: mainTheme,
  ));
}