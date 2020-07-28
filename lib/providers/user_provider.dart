import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _userId;
  DocumentSnapshot _userData;

  String get userId {
    return _userId;
  }

  DocumentSnapshot get userData {
    return _userData;
  }

  Future<void> getUserId() async {
    await FirebaseAuth.instance
        .currentUser()
        .then((value) => _userId = value.uid);
  }

  Future<void> getUserData() async {
    await Firestore.instance
        .collection("users")
        .document(userId)
        .get()
        .then((value) => _userData = value);
  }

  Future<DocumentSnapshot> getUserById(uid) async {
    var data = await Firestore.instance.collection("users").document(uid).get();
    return data;
  }

  void addFriend(String friendUid)  {
     Firestore.instance
        .collection("users")
        .document(friendUid)
        .updateData({
      "friends": FieldValue.arrayUnion([userId])
    });

     Firestore.instance.collection("users").document(userId).updateData({
      "friends": FieldValue.arrayUnion([friendUid])
    });
  }

  void addFriendRequest(String friendUid) {
    Firestore.instance.collection("users").document(friendUid).updateData({
      "requests": FieldValue.arrayUnion([userId])
    });
  }

  void requestAccepted(uid, uid2) {
    Firestore.instance.collection("users").document(uid).updateData({
      "friends": FieldValue.arrayUnion([uid2]),
      "friendsCount": FieldValue.increment(1),
    });
    Firestore.instance.collection("users").document(uid2).updateData({
      "friends": FieldValue.arrayUnion([uid]),
      "friendsCount": FieldValue.increment(1),
    });
    Firestore.instance.collection("users").document(uid).updateData({
      "requests": FieldValue.arrayRemove([uid2]),
    });
  }

  void requestRejected(uid, uid2) {
    Firestore.instance.collection("users").document(uid).updateData({
      "requests": FieldValue.arrayRemove([uid2]),
    });
  }
}
