import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vc_deca_flutter/user_info.dart';
import 'package:vc_deca_flutter/utils/config.dart';
import 'package:vc_deca_flutter/utils/theme.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final storageRef = FirebaseStorage.instance.ref();
  final databaseRef = FirebaseDatabase.instance.reference();

  double _progress = 0.0;
  String uploadStatus = "";
  bool _visible = true;

  List<Widget> permCardList = [
    new Container(
      padding: EdgeInsets.only(top: 16.0),
      child: new Text("permissions".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
    )
  ];

  @override
  void initState() {
    super.initState();
    print(userPerms);
    if (userPerms.contains('DEV') || userPerms.contains('ADMIN')) {
      userPerms.forEach((perm) {
        permCardList.add(
            new ListTile(
              title: new Text(perm, style: TextStyle(color: currTextColor)),
            )
        );
      });
    }
    else {
      permCardList.add(
          new ListTile(
            title: new Text("Hidden", style: TextStyle(color: currTextColor),),
          )
      );
    }
    permCardList.add(
        new ListTile(
          title: new Text("Update Permissions", style: TextStyle(fontFamily: "Product Sans", color: mainColor), textAlign: TextAlign.center,),
          onTap: () {
            router.navigateTo(context, '/settings/update-profile/manage-perms', transition: TransitionType.native);
          },
        )
    );
  }

  Future<void> updateProfile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        maxHeight: 512,
        maxWidth: 512,
      );
      if (croppedImage != null) {
        setState(() {
          _visible = false;
        });
        print("UPLOADING");
        StorageUploadTask profileUploadTask = storageRef.child("users").child("$userID.png").putFile(croppedImage);
        profileUploadTask.events.listen((event) {
          print("UPLOADING: ${event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble()}");
          setState(() {
            uploadStatus = "Uploading - ${event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble() * 100}%";
            _progress = event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble();
          });
        });
        var dowurl = await (await profileUploadTask.onComplete).ref.getDownloadURL();
        var url = dowurl.toString();
        databaseRef.child("users").child(userID).child("profilePicUrl").set(url);
        setState(() {
          profilePic = url;
          _visible = true;
          uploadStatus = "Done!";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: mainColor,
            title: new Text("Update Profile"),
            leading: new Container(
              child: new Visibility(
                child: new IconButton(
                  icon: Icon(Icons.clear),
                  color: Colors.white,
                  onPressed: () {
                    router.pop(context);
                  },
                ),
                visible: _visible,
              ),
            )
        ),
        backgroundColor: currBackgroundColor,
        body: new SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              new Card(
                elevation: 6.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: currCardColor,
                child: new Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      new Container(
                        child: new Text("profile picture".toUpperCase(), style: TextStyle(color: mainColor, fontSize: 18, fontFamily: "Product Sans", fontWeight: FontWeight.bold),),
                      ),
                      new Padding(padding: EdgeInsets.all(8.0)),
                      new GestureDetector(
                        child: new ClipOval(
                          child: new CachedNetworkImage(
                            imageUrl: profilePic,
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.fill,
                          ),
                        ),
                        onTap: updateProfile,
                      ),
                      new Padding(padding: EdgeInsets.all(4.0)),
                      new Text(
                        "(Click to edit)",
                        style: TextStyle(fontFamily: "Product Sans", fontSize: 15.0, color: currTextColor),
                      ),
                    ],
                  ),
                ),
              ),
              new Padding(padding: EdgeInsets.all(4.0)),
              new Card(
                elevation: 6.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                color: currCardColor,
                child: Column(
                  children: permCardList
                ),
              ),
              new Padding(padding: EdgeInsets.all(16.0)),
            ],
          ),
        ),
        bottomNavigationBar: new Visibility(
          visible: !_visible,
          child: new Container(
            padding: EdgeInsets.all(16.0),
            height: 150.0,
            child: new Column(
              children: <Widget>[
                new Text(
                  uploadStatus,
                  style: TextStyle(fontFamily: "Product Sans", fontSize: 25.0),
                ),
                new Padding(padding: EdgeInsets.all(8.0)),
                new LinearProgressIndicator(
                  value: _progress,
                )
              ],
            ),
          ),
        )
    );
  }
}