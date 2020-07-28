import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/question.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class QuestionProvider with ChangeNotifier {
  Future<void> addQuestion(Question question, File imageFile) async {
    try {
      final fileName = Timestamp.now().nanoseconds.toString();
      final ref = FirebaseStorage.instance
          .ref()
          .child("question_images")
          .child(question.creatorId)
          .child(fileName);

      await ref.putFile(imageFile).onComplete;

      final url = await ref.getDownloadURL();

      await Firestore.instance.collection("questions").add(
          question.toJsonForFirestore(
              url, question.creatorId, question.creatorUsername, fileName));
    } on PlatformException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> checkAnswer(documentId) async {
    bool flag = false;
    await Firestore.instance
        .collection("questions")
        .document(documentId)
        .get()
        .then((value) => flag = value.data["isAnswerAccepted"]);
    return flag;
  }

  void updateQuestion(documentId, Map<String, dynamic> data) {
    try {
      Firestore.instance
          .collection("questions")
          .document(documentId)
          .updateData(data);
    } catch (e) {
      throw e;
    }
  }

  void deleteQuestion(documentId, imageUrl, resultImageUrl) {
    try {
      Firestore.instance.collection("questions").document(documentId).delete();

      FirebaseStorage.instance
          .getReferenceFromUrl(imageUrl)
          .then((value) => value.delete());

      if (resultImageUrl != null) {
        FirebaseStorage.instance
            .getReferenceFromUrl(resultImageUrl)
            .then((value) => value.delete());
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> addQuestionResult(documentId, File resultImage, fileName) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      final ref = FirebaseStorage.instance
          .ref()
          .child("question_images")
          .child(user.uid)
          .child(fileName + "-result");

      await ref.putFile(resultImage).onComplete;

      final url = await ref.getDownloadURL();
      Firestore.instance
          .collection("questions")
          .document(documentId)
          .updateData({
        "resultImageUrl": url,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<Question> getQuestionByDocId(docId) async {
    Question data;
    await Firestore.instance
        .collection("questions")
        .document(docId)
        .get()
        .then((value) {
      data = Question.fromJson(value.data);
    });
    return data;
  }

  Stream<QuerySnapshot> fetchAndSetQuestions(
      String selectedFilter, String lessonName) {
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
