import 'package:flutter/foundation.dart';

class Question {
  final String id;
  final String description;
  final String imageUrl;
  final String lesson;
  final String exam;
  final int dateTime;
  final bool isAlarmActive;
  final int alarmDate;
  final String creatorId;
  final String creatorUsername;
  final String resultImageUrl;
  final bool isAnswerAccepted;
  final String fileName;

  Question({
    @required this.id,
    @required this.description,
    @required this.lesson,
    @required this.exam,
    @required this.dateTime,
    @required this.creatorId,
    @required this.creatorUsername,
    this.imageUrl,
    this.fileName,
    this.alarmDate = 0,
    this.isAlarmActive = false,
    this.resultImageUrl,
    this.isAnswerAccepted = false,
  });

  Question.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        description = json["description"],
        imageUrl = json["imageUrl"],
        fileName = json["fileName"],
        lesson = json["lesson"],
        exam = json["exam"],
        dateTime = json["dateTime"],
        isAlarmActive = json["isAlarmActive"],
        alarmDate = json["alarmDate"],
        creatorId = json["creatorId"],
        creatorUsername = json["creatorUsername"],
        resultImageUrl = json["resultImageUrl"],
        isAnswerAccepted =
            json["isAnswerAccepted"] == null ? false : json["isAnswerAccepted"];

  Map<String, dynamic> toJsonForFirestore(imageUrl, uid, username, fileName) =>
      {
        "id": id,
        "description": description,
        "imageUrl": imageUrl,
        "fileName": fileName,
        "lesson": lesson,
        "exam": exam,
        "dateTime": dateTime,
        "isAlarmActive": isAlarmActive,
        "alarmDate": alarmDate,
        "creatorId": uid,
        "creatorUsername": username,
        "resultImageUrl": resultImageUrl,
        "isAnswerAccepted": isAnswerAccepted,
      };
}
