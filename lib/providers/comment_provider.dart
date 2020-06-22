import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/comment.dart';

class CommentProvider with ChangeNotifier {
  Future<void> addComment(Comment comment, questionId) async {
    try {
      await Firestore.instance
          .collection("questions")
          .document(questionId)
          .collection("comments")
          .add(comment.toJson());
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

  Future<void> deleteComment(commentId, questionId) async {
    try {
      await Firestore.instance
          .collection("questions")
          .document(questionId)
          .collection("comments")
          .document(commentId)
          .delete();
    } catch (e) {
      throw e;
    }
  }

  Stream<QuerySnapshot> getComments(questionId) {
    try {
      final allDocs = Firestore.instance
          .collection("questions")
          .document(questionId)
          .collection("comments")
          .orderBy("createdAt")
          .snapshots();
      return allDocs;
    } catch (e) {
      return null;
    }
  }
}
