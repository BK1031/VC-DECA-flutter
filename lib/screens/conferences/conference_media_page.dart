import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class ConferenceMediaPage extends StatefulWidget {
  @override
  _ConferenceMediaPageState createState() => _ConferenceMediaPageState();
}

class _ConferenceMediaPageState extends State<ConferenceMediaPage> {

  final databaseRef = FirebaseDatabase.instance.reference();
  final storageRef = FirebaseStorage.instance.ref();

  bool _visible = true;

  _ConferenceMediaPageState() {
    databaseRef.child("conferences").child(selectedConference.shortName).child("media").onChildAdded.listen((Event event) {
      print(event.snapshot.value);
      setState(() {
        _tiles.add(event.snapshot.value);
      });
    });
    if (userPerms.contains('CONFERENCE_MEDIA_UPLOAD') || userPerms.contains('ADMIN')) {
      setState(() {
        _visible = true;
      });
    }
  }

  List<String> _tiles = <String>[];

//  Future<void> newImage() async {
//    var now = DateTime.now();
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    if (image != null) {
//      print("UPLOADING");
//      StorageUploadTask uploadTask = storageRef.child("conferences").child(selectedYear).child("$now.png").putFile(image);
//      uploadTask.events.listen((event) {
//        print("UPLOADING: ${event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble()}");
//      });
//      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
//      var url = dowurl.toString();
//      databaseRef.child("conferences").child(selectedYear).child("media").push().set(url);
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new Visibility(
        visible: (userPerms.contains('CONFERENCE_MEDIA_UPLOAD') || userPerms.contains('ADMIN')),
        child: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () {},
        ),
      ),
      body: new Container(
          padding: const EdgeInsets.all(8.0),
          child: new StaggeredGridView.countBuilder(
            staggeredTileBuilder: (int index) {
              return new StaggeredTile.count(2, index.isEven ? 2 : 1);
            },
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                color: currCardColor,
                elevation: 6.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: new GestureDetector(
                  onTap: () {
                    selectedImage = _tiles[index];
                    print("Selected Image: $selectedImage");
                    router.navigateTo(context, '/conference/details/media-view', transition: TransitionType.nativeModal);
                  },
                  child: new Container(
                      child: new ClipRRect(
                        child: new CachedNetworkImage(
                          imageUrl: _tiles[index],
                          fit: BoxFit.cover,
                        ),
                        borderRadius: new BorderRadius.all(const Radius.circular(16.0)),
                      )
                  ),
                ),
              );
            },
            crossAxisCount: 4,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            itemCount: _tiles.length,
          )
      ),
    );
  }
}