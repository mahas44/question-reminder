import "package:flutter/foundation.dart";

class Comment {
  final int id;
  final String comment;
  final int createdAt;
  final String createdBy;
  final String creatorUsername;
  final String creatorImage;

  Comment({
    @required this.id,
    @required this.comment,
    @required this.createdAt,
    @required this.createdBy,
    @required this.creatorUsername,
    @required this.creatorImage,
  });

  Comment.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson["id"],
        comment = parsedJson["comment"],
        createdAt = parsedJson["createdAt"],
        createdBy = parsedJson["createdBy"],
        creatorUsername = parsedJson["creatorUsername"],
        creatorImage = parsedJson["creatorImage"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "creatorUsername": creatorUsername,
        "creatorImage": creatorImage,
      };
}
