import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:question_reminders/helpers/db_helper.dart';
import '../models/question.dart';
import 'package:flutter/foundation.dart';

class QuestionProvider with ChangeNotifier {

  Future<void> addQuestion(Question question) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      final ref = FirebaseStorage.instance
          .ref()
          .child("question_images")
          .child(user.uid)
          .child(Timestamp.now().nanoseconds.toString() + ".jpg");

      await ref.putFile(question.imageFile).onComplete;

      final url = await ref.getDownloadURL();

      bool isAlarmActive = question.isAlarmActive == 0 ? false : true;

      DBHelper.insert("questions", question.toJson(url));

      await Firestore.instance
          .collection("questions")
          .add(question.toJsonForFirestore(isAlarmActive, url, user.uid));
    } on PlatformException catch (e) {
      var message = "An error occured, please check your credentials";

      if (e.message != null) {
        message = e.message;
      }
      print(message);
    } catch (e) {
      throw e;
    }
  }

  Stream<QuerySnapshot> fetchAndSetPlaces(String selectedFilter) {
    try {
      final allDocs = Firestore.instance
          .collection("questions")
          .where("exam", isEqualTo: selectedFilter)
          .orderBy("dateTime", descending: true)
          .snapshots();
      return allDocs;
    } catch (e) {
      return null;
    }
  }

  Stream<QuerySnapshot> getQuestionByUserId(String id) {
    try {
      final allDocs = Firestore.instance
          .collection("questions")
          .where("createdBy", isEqualTo: id)
          .orderBy("dateTime", descending: true)
          .snapshots();
      return allDocs;
    } catch (e) {
      return null;
    }
  }

  
}
