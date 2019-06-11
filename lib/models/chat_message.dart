import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vc_deca_flutter/utils/hex_color.dart';

class ChatMessage {
  String key;
  String message;
  String author;
  String authorID;
  String authorRole;
  String mediaType;
  String messageColor;
  bool nsfw;

  ChatMessage(this.message, this.author, this.authorRole);

  ChatMessage.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        message = snapshot.value["message"].toString(),
        authorRole = snapshot.value["role"].toString(),
        authorID = snapshot.value["userID"].toString(),
        mediaType = snapshot.value["type"].toString(),
        messageColor = snapshot.value["color"].toString(),
        nsfw = snapshot.value["nsfw"],
        author = snapshot.value["author"].toString();

  toJson() {
    return {
      "message": message,
      "author": author
    };
  }
}