import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/comment.dart';

class CommentProvider with ChangeNotifier {
  Future<void> addComment(
      Comment comment, questionDocumentID, questionId) async {
    try {
      await Firestore.instance
          .collection("questions")
          .document(questionDocumentID)
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

  Future<void> deleteComment(
      commentDocumentId, questionDocumentID, commentId) async {
    try {
      await Firestore.instance
          .collection("questions")
          .document(questionDocumentID)
          .collection("comments")
          .document(commentDocumentId)
          .delete();
    } catch (e) {
      throw e;
    }
  }

  Stream<QuerySnapshot> getComments(questionDocumentID) {
    try {
      final allDocs = Firestore.instance
          .collection("questions")
          .document(questionDocumentID)
          .collection("comments")
          .orderBy("score", descending: true)
          .orderBy("createdAt", descending: true)
          .snapshots();
      return allDocs;
    } catch (e) {
      return null;
    }
  }

  Future<void> setAnswerComment(questionDocId, commentDocId, data) async {
     try {
      await Firestore.instance
          .collection("questions")
          .document(questionDocId)
          .collection("comments")
          .document(commentDocId)
          .updateData(data);
    } catch (e) {
      throw e;
    }
  }

  Future getAnswerComment(questionDocId) async{
    var query = await Firestore.instance
        .collection("questions")
        .document(questionDocId)
        .collection("comments")
        .where("isAnswer", isEqualTo: true)
        .limit(1)
        .getDocuments();
    if (query.documents.length > 0) {
      return query.documents[0];
    } else {
      return null;
    }
  }
}
