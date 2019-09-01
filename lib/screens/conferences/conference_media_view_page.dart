import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';

class ConferenceMediaViewPage extends StatefulWidget {
  @override
  _ConferenceMediaViewPageState createState() => _ConferenceMediaViewPageState();
}

class _ConferenceMediaViewPageState extends State<ConferenceMediaViewPage> {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Container(
          child: new PhotoView(
            imageProvider: new NetworkImage(selectedImage),
            minScale: PhotoViewComputedScale.contained,
            transitionOnUserGestures: true,
          ),
        ),
        new SafeArea(
          child: new Material(
            color: Colors.transparent,
            child: new IconButton(
              icon: Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                router.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}
