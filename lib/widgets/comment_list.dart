import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/providers/comment_provider.dart';
import 'package:question_reminders/widgets/comment_item.dart';
import 'package:question_reminders/widgets/new_comment.dart';

class CommentList extends StatefulWidget {
  final String questionId, questionDocumentID;
  CommentList(this.questionId, this.questionDocumentID);
  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    var userId;
    return Column(
      children: [
        Expanded(
          child:buildFutureBuilder(userId),
        ),
          NewComment(widget.questionDocumentID, widget.questionId)
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
                    "Bu soru için henüz yorum yapılmamıştır.İlk yorumu yapan siz olun.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              );
            }
            final docs = snapshot.data.documents;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (ctx, i) => CommentItem(
                userId,
                widget.questionDocumentID,
                widget.questionId,
                docs[i],
              ),
            );
          },
        );
      },
    );
  }
}
