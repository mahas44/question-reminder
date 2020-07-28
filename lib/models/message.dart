import 'package:flutter/material.dart';

class Message with ChangeNotifier {
  String message;
  int createdAt;
  // String username;
  // String userId;
  String idTo, idFrom;

  Message({
    @required this.idTo,
    @required this.message,
    @required this.idFrom,
    @required this.createdAt,
  });

  Message.fromJson(Map<String, dynamic> json)
      : idTo = json["idTo"],
        message = json["message"],
        idFrom = json["idFrom"],
        createdAt = json["createdAt"];

  Map<String, dynamic> toJson() => {
    "idTo": idTo,
    "message": message,
    "idFrom": idFrom,
    "createdAt": createdAt,
  };
}
