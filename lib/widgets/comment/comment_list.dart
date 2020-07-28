import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/models/question.dart';
import 'package:question_reminders/providers/comment_provider.dart';
import 'package:question_reminders/providers/question_provider.dart';
import 'package:question_reminders/widgets/comment/comment_item.dart';
import 'package:question_reminders/widgets/comment/new_comment.dart';

class CommentList extends StatefulWidget {
  final Question question;
  final String questionDocumentID;
  final String type;
  CommentList(this.question, this.questionDocumentID, {this.type});

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  var _data;
  bool flag = false;
  void getAnswer() async {
    if (!flag) {
      await Provider.of<QuestionProvider>(context, listen: false)
          .getQuestionByDocId(widget.questionDocumentID)
          .then((value) => questionData = value);
    }

    _data = await Provider.of<CommentProvider>(context, listen: false)
        .getAnswerComment(widget.questionDocumentID);
  }

  Question questionData;
  @override
  initState() {
    super.initState();
    questionData = widget.question;
    if (widget.question.isAnswerAccepted == null) {
      flag = false;
    } else {
      flag = widget.question.isAnswerAccepted;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAnswer();
  }

  @override
  Widget build(BuildContext context) {
    var userId;
    return 
    Column(
      children: [
        Expanded(
          flex: 1,
          child: buildFutureBuilder(userId),
        ),
        NewComment(widget.questionDocumentID, widget.question.id)
      ],
    );
  }

  FutureBuilder<String> buildFutureBuilder(userId) {
    return FutureBuilder(
      future: FirebaseAuth.instance
          .currentUser()
          .then((value) => userId = value.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Provider.of<CommentProvider>(context)
              .getComments(widget.questionDocumentID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Bu soru için henüz yorum yapılmamıştır.İlk yorumu yapan siz olmak ister misiniz?.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              );
            }
            final List<dynamic> docs = snapshot.data.documents;
            if (_data != null) {
              var score = docs.firstWhere(
                  (element) => element["id"] == _data["id"])["score"];
              var scoredBy = docs.firstWhere(
                  (element) => element["id"] == _data["id"])["scoredBy"];
              _data.data["score"] = score;
              _data.data["scoredBy"] = scoredBy;
              docs.removeWhere((element) => element["id"] == _data["id"]);
            }

            return ListView.builder(
              itemCount: _data != null ? docs.length + 1 : docs.length,
              itemBuilder: (ctx, i) {
                int index = i;
                if (_data != null) {
                  if (i < 1) {
                    return CommentItem(
                      userId,
                      widget.questionDocumentID,
                      widget.question.creatorId,
                      _data,
                      flag,
                      type :widget.type,
                      onAnswerSelect: (value) {
                        setState(() {
                          flag = value;
                        });
                      },
                      onScoreChange: (value) {
                        setState(() {
                          getAnswer();
                        });
                      },
                    );
                  }
                  index = i - 1;
                }
                return CommentItem(
                  userId,
                  widget.questionDocumentID,
                  widget.question.creatorId,
                  docs[index],
                  flag,
                  type :widget.type,
                  onAnswerSelect: (value) {
                    setState(() {
                      flag = value;
                    });
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
