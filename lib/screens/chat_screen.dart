import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:question_reminders/widgets/message/messages.dart';
import 'package:question_reminders/widgets/message/new_message.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = "/chat-room";
  final String chatRoomId, idTo;
  final DocumentSnapshot receiverUserdata;
  ChatScreen({
    @required this.chatRoomId,
    @required this.idTo,
    @required this.receiverUserdata,
  });
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.of(context).pop();
        },),
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.receiverUserdata.data["imageUrl"],
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Text(widget.receiverUserdata.data["username"]),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(
                chatRoomId: widget.chatRoomId,
                receiverUserdata: widget.receiverUserdata,
              ),
            ),
            NewMessage(
              chatRoomId: widget.chatRoomId,
              idTo: widget.idTo,
            ),
          ],
        ),
      ),
    );
  }
}
