import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/constant.dart';
import 'package:provider/provider.dart';
import '../providers/comment_provider.dart';

class CommentItem extends StatefulWidget {
  final dynamic comment;
  final String questionDocumentID;
  final String questionId;
  final String userId;

  CommentItem(
      this.userId, this.questionDocumentID, this.questionId, this.comment);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  int incrementCount = 0, decrementCount = 0;

  Future<void> _updateScore(bool isIncrement) async {
    int count;
    if (isIncrement) {
      count = 1;
      incrementCount += 1;
      decrementCount -= 1;
    } else {
      count = -1;
      decrementCount += 1;
      incrementCount -= 1;
    }
    await Firestore.instance
        .collection("questions")
        .document(widget.questionDocumentID)
        .collection("comments")
        .document(widget.comment.documentID)
        .updateData(
      {
        "score": FieldValue.increment(count),
        "scoredBy": FieldValue.arrayUnion([widget.userId]),
      },
    ).then(
      (value) => Firestore.instance
          .collection("users")
          .document(widget.comment["createdBy"])
          .updateData(
        {
          "score": FieldValue.increment(count),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_up),
                      onPressed: widget.comment["scoredBy"]
                              .toList()
                              .contains(widget.userId)
                          ? null
                          : () => _updateScore(true),
                    ),
                    Text("${widget.comment["score"]}"),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_down),
                      onPressed: widget.comment["scoredBy"]
                              .toList()
                              .contains(widget.userId)
                          ? null
                          : () => _updateScore(false),
                    )
                  ],
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.comment["creatorImage"]),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.comment["creatorUsername"],
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Row(
                      children: [
                         Container(
                            width: widget.comment["createdBy"] == widget.userId
                                ? deviceSize.width * 0.5
                                : deviceSize.width * 0.6,
                            child: Text(
                              widget.comment["comment"],
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        
                        if (widget.comment["createdBy"] == widget.userId)
                          IconButton(
                            icon: Icon(
                              Icons.delete_forever,
                              color: kShrineErrorRed,
                            ),
                            onPressed: () async {
                              try {
                                Provider.of<CommentProvider>(context,
                                        listen: false)
                                    .deleteComment(
                                        widget.comment.documentID,
                                        widget.questionDocumentID,
                                        widget.comment["id"]);
                              } catch (e) {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                    "Deleting failed!",
                                    textAlign: TextAlign.center,
                                  )),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                    Text(
                      format.format(
                        DateTime.fromMillisecondsSinceEpoch(
                            widget.comment["createdAt"]),
                      ),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 2,
          color: Colors.grey,
        )
      ],
    );
  }
}
