import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/providers/user_provider.dart';
import 'package:question_reminders/widgets/message/message_bubble.dart';

class Messages extends StatelessWidget {
  final chatRoomId;
  final DocumentSnapshot receiverUserdata;

  Messages({@required this.chatRoomId, this.receiverUserdata});

  @override
  Widget build(BuildContext context) {
    var uid = Provider.of<UserProvider>(context, listen: false).userId;
    var userData = Provider.of<UserProvider>(context, listen: false).userData;
    return StreamBuilder(
      stream: Firestore.instance
          .collection("chats")
          .document(chatRoomId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data["messages"] as List;
        chatDocs.sort((a,b){
          return b["createdAt"].compareTo(a["createdAt"]);
        });
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => chatDocs[index]["idFrom"] == uid
              ? MessageBubble(
                  chatDocs[index]["message"],
                  userData.data["username"],
                  chatDocs[index]["createdAt"],
                  true,
                )
              : MessageBubble(
                  chatDocs[index]["message"],
                  receiverUserdata.data["username"],
                  chatDocs[index]["createdAt"],
                  false,
                ),
        );
      },
    );
  }
}
