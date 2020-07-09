import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/models/comment.dart';
import 'package:question_reminders/providers/comment_provider.dart';
import 'package:question_reminders/widgets/accent_color_override.dart';

class NewComment extends StatefulWidget {
  final String questionDocumentID, questionId;
  NewComment(this.questionDocumentID, this.questionId);

  @override
  _NewCommentsState createState() => _NewCommentsState();
}

class _NewCommentsState extends State<NewComment> {
  var _enteredMessage = "";
  final _controller = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection("users").document(user.uid).get();

    var time = Timestamp.now();
    Comment comment = Comment(
      id: time.nanoseconds,
      comment: _enteredMessage,
      createdAt: time.millisecondsSinceEpoch,
      createdBy: user.uid,
      creatorUsername: userData["username"],
      creatorImage: userData["imageUrl"],
      scoredBy: ["${user.uid}"],
      score: 0,
    );

    Provider.of<CommentProvider>(context, listen: false)
        .addComment(comment, widget.questionDocumentID, widget.questionId);

    _enteredMessage = "";
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        left: 10,
        right: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: AccentColorOverride(
              color: kShrineBrown900,
              child: TextField(
                maxLength: 140,
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(labelText: "Yorum veya cevap yaz"),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                  });
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
