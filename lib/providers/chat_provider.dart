import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  void createdChatRoom(String uid, String uid2) {
    Firestore.instance.collection("chats").document().setData({
      "peers": [uid, uid2],
      "lastMessage": "",
      "lastMessageDate": null,
      "messages": [],
    });
  }
}
