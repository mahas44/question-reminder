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

  Comment({
    @required this.id,
    @required this.comment,
    @required this.createdAt,
    @required this.createdBy,
    @required this.creatorUsername,
    @required this.creatorImage,
    this.score = 0,
    this.scoredBy,
  });

  Comment.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        comment = parsedJson["comment"],
        createdAt = parsedJson["createdAt"],
        createdBy = parsedJson["createdBy"],
        creatorUsername = parsedJson["creatorUsername"],
        creatorImage = parsedJson["creatorImage"],
        score = parsedJson["score"],
        scoredBy = parsedJson["scoredBy"];
        

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "creatorUsername": creatorUsername,
        "creatorImage": creatorImage,
        "score": score,
        "scoredBy": scoredBy,
      };


}
