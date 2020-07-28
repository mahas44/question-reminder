import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:question_reminders/models/exam.dart';
import 'package:question_reminders/models/lesson.dart';

class ConstantProvider with ChangeNotifier{
  Map<String, dynamic> _exams = {};
  Map<String, List<Lesson>> _lessons = {};
  List<Exam> _examList = [];

  void clear() {
    _exams = {};
    _lessons = {};
    _examList = [];
  }

  List<Exam> get examList {
    return [..._examList];
  }

  Map<String, dynamic> get exam {
    return _exams;
  }

  Map<String, List<Lesson>> get lessons {
    return _lessons;
  }

  void examObjectList() {
    for (var i = 0; i < _exams.length; i++) {
      _examList.add(Exam(id: i,title: _exams.keys.elementAt(i),color: Colors.blueGrey));
    }
  }

  void lessonList() {
    List<Lesson> list = [];
    _exams.forEach((key, value) {
      for (var i = 0; i < value.length; i++) {
        list.add(Lesson(id: i, name: value[i]));
      }
      _lessons.putIfAbsent(key, () => list);
      list = [];
    });
  }

  Future<void> getExams() async {
    try {
      print("getExams");
      await Firestore.instance
          .collection("constants")
          .getDocuments()
          .then((value) {
            value.documents[0].data.forEach((key, value) {
              _exams[key] = value;
            });
            notifyListeners();
          });

    } catch (e) {
      throw e;
    }
  }
}
