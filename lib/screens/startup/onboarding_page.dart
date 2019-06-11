import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  final pages = [
    new PageViewModel(
        pageColor: mainColor,
        iconImageAssetPath: 'images/events.png',
        body: Text(
          'View conference schedules to keep on top of all your DECA events',
        ),
        title: Text(
          'Events',
        ),
        textStyle: TextStyle(fontFamily: 'Product Sans', color: Colors.white),
        mainImage: Image.asset(
          'images/events.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )
    ),
    new PageViewModel(
      pageColor: mainColor,
      iconImageAssetPath: 'images/alert.png',
      body: Text(
        'Be notified of imporant updates, including when your next event is about to start',
      ),
      title: Text('Alerts'),
      mainImage: Image.asset(
        'images/alert.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'Product Sans', color: Colors.white),
    ),
    new PageViewModel(
      pageColor: mainColor,
      iconImageAssetPath: 'images/map.png',
      body: Text(
        'Find event locations quickly with our built-in maps',
      ),
      title: Text('Maps'),
      mainImage: Image.asset(
        'images/map.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'Product Sans', color: Colors.white),
    ),
    new PageViewModel(
      pageColor: mainColor,
      iconImageAssetPath: 'images/platform.png',
      body: Text(
        'Easy access from all your favorite devices',
      ),
      title: Text(
        'Multi-Platform',
        textAlign: TextAlign.center,
      ),
      mainImage: Image.asset(
        'images/platform.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'Product Sans', color: Colors.white),
    ),
    new PageViewModel(
      pageColor: mainColor,
      iconImageAssetPath: 'images/logo_white_trans.png',
      body: Text(
        'Click done to get started!',
      ),
      title: Text('Welcome to', textAlign: TextAlign.center,),
      mainImage: Image.asset(
        'images/logo_white_trans.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'Product Sans', color: Colors.white),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: mainColor,
      child: new SafeArea(
        child: new IntroViewsFlutter(
          pages,
          onTapDoneButton: () {
            router.navigateTo(context,'/register', transition: TransitionType.fadeIn, clearStack: true);
          },
          columnMainAxisAlignment: MainAxisAlignment.start,
          showSkipButton: false,
          pageButtonTextStyles: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );

  }
}
