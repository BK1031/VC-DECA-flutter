import 'package:firebase_database/firebase_database.dart';

class ChatMessage {
  String key;
  String message;
  String author;
  String authorID;
  String authorRole;
  String mediaType;
  String customColor;
  String profileUrl;
  String timestamp;
  bool nsfw;
  bool repeatAuthor;

  ChatMessage(this.message, this.author, this.authorRole);

  ChatMessage.fromSnapshot(DataSnapshot snapshot, bool repeatAuthor)
      : key = snapshot.key,
        message = snapshot.value["message"].toString(),
        authorRole = snapshot.value["role"].toString(),
        authorID = snapshot.value["userID"].toString(),
        mediaType = snapshot.value["type"].toString(),
        customColor = snapshot.value["color"].toString(),
        profileUrl = snapshot.value["profileUrl"].toString(),
        timestamp = snapshot.value["date"].toString(),
        nsfw = snapshot.value["nsfw"],
        this.repeatAuthor = repeatAuthor,
        author = snapshot.value["author"].toString();

  toJson() {
    return {
      "message": message,
      "author": author
    };
  }
}