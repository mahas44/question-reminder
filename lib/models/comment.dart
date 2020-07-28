import "package:flutter/foundation.dart";

class Comment {
  final int id;
  final String comment;
  final int createdAt;
  final String createdBy;
  final String creatorUsername;
  final String creatorImage;
  final int score;
  List<String> scoredBy;
  final bool isAnswer;

  Comment({
    @required this.id,
    @required this.comment,
    @required this.createdAt,
    @required this.createdBy,
    @required this.creatorUsername,
    @required this.creatorImage,
    this.score = 0,
    this.scoredBy,
    this.isAnswer = false,
  });

  Comment.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        comment = json["comment"],
        createdAt = json["createdAt"],
        createdBy = json["createdBy"],
        creatorUsername = json["creatorUsername"],
        creatorImage = json["creatorImage"],
        score = json["score"],
        scoredBy = json["scoredBy"],
        isAnswer = json["isAnswer"] == null ? false : json["isAnswer"];
        

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "creatorUsername": creatorUsername,
        "creatorImage": creatorImage,
        "score": score,
        "scoredBy": scoredBy,
        "isAnswer": isAnswer,
      };


}
