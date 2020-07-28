import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/providers/question_provider.dart';
import 'package:question_reminders/providers/user_provider.dart';
import 'package:question_reminders/screens/profile_screen.dart';
import '../../providers/comment_provider.dart';

typedef AnswerCallback = void Function(bool flag);
typedef ScoreCallback = void Function(bool flag);
var format = DateFormat("d MMM y HH:mm", "tr_TR");

class CommentItem extends StatefulWidget {
  final dynamic comment;
  final String questionDocumentID;
  final String creatorId;
  final String userId;
  final String type;
  final bool isAnswerAccepted;

  final AnswerCallback onAnswerSelect;
  final ScoreCallback onScoreChange;

  CommentItem(this.userId, this.questionDocumentID, this.creatorId,
      this.comment, this.isAnswerAccepted,
      {this.onAnswerSelect, this.onScoreChange, this.type});

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  DocumentSnapshot userData;


  @override
  void initState() {
    super.initState();
    getCommentBy();
  }

  void getCommentBy() async {
    await Provider.of<UserProvider>(context, listen: false)
        .getUserById(widget.comment["createdBy"])
        .then((value) => userData = value);
  }

  Future<void> _updateScore(bool isIncrement) async {
    int count;
    if (isIncrement) {
      count = 1;
    } else {
      count = -1;
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      if (widget.comment["isAnswer"])
                        Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () async{
                          var user = await Provider.of<UserProvider>(context, listen: false).getUserById(widget.comment["createdBy"]);
                          Map<String, dynamic> data = {
                            "type": "look",
                            "userData": user
                          };
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                              settings: RouteSettings(arguments: data),
                            ),
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              onBackgroundImageError: (exception, stackTrace) =>
                                  Image.asset("assets/icon.png"),
                              backgroundImage:
                                  NetworkImage(widget.comment["creatorImage"]),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              widget.comment["creatorUsername"],
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_up),
                      onPressed: widget.comment["scoredBy"]
                              .toList()
                              .contains(widget.userId)
                          ? null
                          : () {
                              _updateScore(true);
                              setState(() {
                                widget.onScoreChange(true);
                              });
                            },
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
              ),
              if(widget.type != "look")
              Expanded(
                flex: 1,
                child: menuItem(context),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.comment["comment"],
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              format.format(
                DateTime.fromMillisecondsSinceEpoch(
                    widget.comment["createdAt"]),
              ),
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Divider(
            color: Colors.black45,
          ),
        ],
      ),
    );
  }

  Widget menuItem(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      onSelected: (value) {
        switch (value) {
          case "Sil":
            try {
              Provider.of<CommentProvider>(context, listen: false)
                  .deleteComment(widget.comment.documentID,
                      widget.questionDocumentID, widget.comment["id"]);
            } catch (e) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                  "Deleting failed!",
                  textAlign: TextAlign.center,
                )),
              );
            }
            break;
          case "Cevap":
            Provider.of<CommentProvider>(context, listen: false)
                .setAnswerComment(
              widget.questionDocumentID,
              widget.comment.documentID,
              {"isAnswer": true},
            );
            Provider.of<QuestionProvider>(context, listen: false)
                .updateQuestion(
              widget.questionDocumentID,
              {"isAnswerAccepted": true},
            );
            Firestore.instance
                .collection("users")
                .document(widget.comment["createdBy"])
                .updateData(
              {
                "score": FieldValue.increment(5),
              },
            );
            setState(() {
              widget.onAnswerSelect(true);
            });

            break;
          default:
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: "Bildir",
          child: ListTile(
            leading: const Icon(Icons.report),
            title: Text("Rapor Et"),
          ),
        ),
        if (!widget.isAnswerAccepted && widget.userId == widget.creatorId)
          PopupMenuItem(
            value: "Cevap",
            child: ListTile(
              leading: const Icon(Icons.check),
              title: Text("Cevap Olarak İşaretle"),
            ),
          ),
        if (widget.userId == widget.creatorId ||
            widget.userId == widget.comment["createdBy"])
          PopupMenuItem(
            value: "Sil",
            child: ListTile(
              leading: const Icon(Icons.delete_forever),
              title: Text("Sil"),
            ),
          ),
      ],
    );
  }
}
