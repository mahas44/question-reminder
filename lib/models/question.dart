import 'dart:io';
import 'package:flutter/foundation.dart';

class Question {
  final String id;
  final String description;
  final String imageUrl;
  final String lesson;
  final String exam;
  final int dateTime;
  final int isAlarmActive;
  final int alarmDate;
  final File imageFile;
  final String createdBy;

  Question({
    @required this.id,
    @required this.description,
    this.imageUrl,
    @required this.lesson,
    @required this.exam,
    @required this.dateTime,
    @required this.imageFile,
    this.alarmDate = 0,
    this.isAlarmActive = 0,
    this.createdBy,
  });

  Question.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        description = parsedJson["description"],
        imageUrl = parsedJson["imageUrl"],
        lesson = parsedJson["lesson"],
        exam = parsedJson["exam"],
        dateTime = parsedJson["dateTime"],
        isAlarmActive = parsedJson["isAlarmActive"] == true ? 1 : 0,
        alarmDate = parsedJson["alarmDate"],
        imageFile = File.fromUri(Uri.parse(parsedJson["imageFile"])),
        createdBy = parsedJson["createdBy"];

  Map<String, dynamic> toJson(url) => {
        "id": id,
        "description": description,
        "imageUrl": url,
        "lesson": lesson,
        "exam": exam,
        "dateTime": dateTime,
        "isAlarmActive": isAlarmActive,
        "alarmDate": alarmDate,
        "imageFile": imageFile.path,
      };
  Map<String, dynamic> toJsonForFirestore(isAlarmActive, url, uid) => {
        "id": id,
        "description": description,
        "imageUrl": url,
        "lesson": lesson,
        "exam": exam,
        "dateTime": dateTime,
        "isAlarmActive": isAlarmActive,
        "alarmDate": alarmDate,
        "imageFile": imageFile.path,
        "createdBy": uid,
      };
}
