import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/constant.dart';
import 'package:question_reminders/providers/comment_provider.dart';
import 'package:question_reminders/widgets/new_comment.dart';

class CommentList extends StatefulWidget {
  final String documentID;
  CommentList(this.documentID);
  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {

  @override
  Widget build(BuildContext context) {
  var userId = "";
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: FirebaseAuth.instance.currentUser().then((value) => userId = value.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return StreamBuilder(
                stream: Provider.of<CommentProvider>(context)
                    .getComments(widget.documentID),
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
                    itemBuilder: (ctx, i) => Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(docs[i]["creatorImage"]),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  docs[i]["creatorUsername"],
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    docs[i]["comment"],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      format.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            docs[i]["createdAt"]),
                                      ),
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                    if (docs[i]["createdBy"] == userId)
                                      IconButton(
                                        iconSize: 20,
                                        icon: Icon(Icons.delete),
                                        color: Theme.of(context).errorColor,
                                        onPressed: () async {
                                          try {
                                            Provider.of<CommentProvider>(
                                                    context,
                                                    listen: false)
                                                .deleteComment(
                                                    docs[i].documentID,
                                                    widget.documentID);
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        NewComment(widget.documentID)
      ],
    );
  }
}
