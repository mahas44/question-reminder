import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:question_reminders/helpers/db_helper.dart';
import '../models/question.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class QuestionProvider with ChangeNotifier {
  List<Question> _items = [];

  List<Question> get items {
    return [..._items];
  }

  Future<void> addQuestion(Question question) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      final userData = await Firestore.instance.collection("users").document(user.uid).get();
      final ref = FirebaseStorage.instance
          .ref()
          .child("question_images")
          .child(user.uid)
          .child(Timestamp.now().nanoseconds.toString() + ".jpg");

      await ref.putFile(question.imageFile).onComplete;

      final url = await ref.getDownloadURL();

      _items.add(Question.fromJson(
          question.toJsonForFirestore(url, user.uid, userData["username"])));
      notifyListeners();
      DBHelper.insert("questions", question.toJsonLocal(url, user.uid, userData["username"]));

      await Firestore.instance
          .collection("questions")
          .add(question.toJsonForFirestore(url, user.uid, userData["username"]));
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

  Future<void> updateQuestion(documentId, Map<String, dynamic> data) async {
    try {
      await Firestore.instance
          .collection("questions")
          .document(documentId)
          .updateData(data);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteQuestion(documentId) async {
    try {
      await Firestore.instance
          .collection("questions")
          .document(documentId)
          .delete();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addQuestionResult(documentId, File resultImage) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      final ref = FirebaseStorage.instance
          .ref()
          .child("question_images")
          .child(user.uid)
          .child(Timestamp.now().nanoseconds.toString() + "-result.jpg");

      await ref.putFile(resultImage).onComplete;

      final url = await ref.getDownloadURL();
      await Firestore.instance
          .collection("questions")
          .document(documentId)
          .updateData({
        "resultImageUrl": url,
        "resultFile": resultImage.path,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchAndSetQuestionsLocal(String selectedFilter) async {
    final dataList = await DBHelper.getData("questions");
    _items = dataList.map((item) => Question.fromJsonLocal(item)).toList();
  }

  Stream<QuerySnapshot> fetchAndSetQuestions(String selectedFilter, String lessonName) {
    try {
      final allDocs = Firestore.instance
          .collection("questions")
          .where("exam", isEqualTo: selectedFilter)
          .where("lesson", isEqualTo: lessonName)
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
          .where("creatorId", isEqualTo: id)
          .orderBy("dateTime", descending: true)
          .snapshots();
      return allDocs;
    } catch (e) {
      return null;
    }
  }
}
