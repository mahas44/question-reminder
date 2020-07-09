import 'dart:io';
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
  final File imageFile;
  final String creatorId;
  final String creatorUsername;
  final String resultImageUrl;
  final File resultFile;

  Question({
    @required this.id,
    @required this.description,
    this.imageUrl,
    @required this.lesson,
    @required this.exam,
    @required this.dateTime,
    @required this.imageFile,
    this.alarmDate = 0,
    this.isAlarmActive = false,
    this.creatorId,
    this.creatorUsername,
    this.resultImageUrl,
    this.resultFile,
  });

  Question.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        description = parsedJson["description"],
        imageUrl = parsedJson["imageUrl"],
        lesson = parsedJson["lesson"],
        exam = parsedJson["exam"],
        dateTime = parsedJson["dateTime"],
        isAlarmActive = parsedJson["isAlarmActive"],
        alarmDate = parsedJson["alarmDate"],
        imageFile = File.fromUri(Uri.parse(parsedJson["imageFile"])),
        creatorId = parsedJson["creatorId"],
        creatorUsername = parsedJson["creatorUsername"],
        resultImageUrl = parsedJson["resultImageUrl"],
        resultFile = parsedJson["resultFile"] == null ? null : File.fromUri(Uri.parse(parsedJson["resultFile"]));


        Question.fromJsonLocal(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        description = parsedJson["description"],
        imageUrl = parsedJson["imageUrl"],
        lesson = parsedJson["lesson"],
        exam = parsedJson["exam"],
        dateTime = parsedJson["dateTime"],
        isAlarmActive = parsedJson["isAlarmActive"] == 1 ? true : false,
        alarmDate = parsedJson["alarmDate"],
        imageFile = File.fromUri(Uri.parse(parsedJson["imageFile"])),
        creatorId = parsedJson["creatorId"],
        creatorUsername = parsedJson["creatorUsername"],
        resultImageUrl = parsedJson["resultImageUrl"],
        resultFile = parsedJson["resultFile"] == null ? null : File.fromUri(Uri.parse(parsedJson["resultFile"]));

  Map<String, dynamic> toJsonLocal(String url, uid, username) => {
        "id": id,
        "description": description,
        "imageUrl": url,
        "lesson": lesson,
        "exam": exam,
        "dateTime": dateTime,
        "isAlarmActive": isAlarmActive == true ? 1 : 0,
        "alarmDate": alarmDate,
        "imageFile": imageFile.path,
        "creatorId": uid,
        "creatorUsername": username,
        "resultImageUrl": resultImageUrl,
        "resultFile": resultFile == null ? null : resultFile.path,
      };

  Map<String, dynamic> toJsonForFirestore(url, uid, username) => {
        "id": id,
        "description": description,
        "imageUrl": url,
        "lesson": lesson,
        "exam": exam,
        "dateTime": dateTime,
        "isAlarmActive": isAlarmActive,
        "alarmDate": alarmDate,
        "imageFile": imageFile.path,
        "creatorId": uid,
        "creatorUsername": username,
        "resultImageUrl": resultImageUrl,
        "resultFile": resultFile == null ? null : resultFile.path,
      };
}
