import 'package:flutter/material.dart';
import 'package:vc_deca/user_info.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:fluro/fluro.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}


class _OnboardingPageState extends State<OnboardingPage> {

  final pages = [
    new PageViewModel(
        pageColor: Colors.blue,
        iconImageAssetPath: 'images/events.png',
        iconColor: null,
        bubbleBackgroundColor: null,
        body: Text(
          'View conference schedules to keep on top of all your DECA events',
        ),
        title: Text(
          'Events',
        ),
        textStyle: TextStyle(fontFamily: 'Regular', color: Colors.white),
        mainImage: Image.asset(
          'images/events.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )
    ),
    new PageViewModel(
      pageColor: Colors.blue,
      iconImageAssetPath: 'images/alert.png',
      iconColor: null,
      bubbleBackgroundColor: null,
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
      textStyle: TextStyle(fontFamily: 'Regular', color: Colors.white),
    ),
    new PageViewModel(
      pageColor: Colors.blue,
      iconImageAssetPath: 'images/map.png',
      iconColor: null,
      bubbleBackgroundColor: null,
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
      textStyle: TextStyle(fontFamily: 'Regular', color: Colors.white),
    ),
    new PageViewModel(
      pageColor: Colors.blue,
      iconImageAssetPath: 'images/platform.png',
      iconColor: null,
      bubbleBackgroundColor: null,
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
      textStyle: TextStyle(fontFamily: 'Regular', color: Colors.white),
    ),
    new PageViewModel(
      pageColor: Colors.blue,
      iconImageAssetPath: 'images/logo_white_trans.png',
      iconColor: null,
      bubbleBackgroundColor: null,
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
      textStyle: TextStyle(fontFamily: 'Regular', color: Colors.white),
    )
  ];


  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.blue,
      child: new SafeArea(
        child: new IntroViewsFlutter(
          pages,
          onTapDoneButton: () {
            router.navigateTo(context,'/toRegister', transition: TransitionType.fadeIn, clearStack: true);
          },
          columnMainAxisAlignment: MainAxisAlignment.start,
          showSkipButton: false, //Whether you want to show the skip button or not.
          pageButtonTextStyles: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
