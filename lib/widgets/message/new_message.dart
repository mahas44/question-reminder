import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/providers/user_provider.dart';

class NewMessage extends StatefulWidget {
  final String chatRoomId, idTo;

  NewMessage({
    @required this.chatRoomId,
    @required this.idTo,
  });
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = "";
  final _controller = new TextEditingController();

  void _sendMessage() async {
    final uid = Provider.of<UserProvider>(context, listen: false).userId;
    int createdAt = Timestamp.now().millisecondsSinceEpoch;
    var element = [
      {
        "message": _enteredMessage,
        "createdAt": createdAt,
        "idTo": widget.idTo,
        "idFrom": uid
      }
    ];
    FocusScope.of(context).unfocus();
    Firestore.instance
        .collection("chats")
        .document(widget.chatRoomId)
        .updateData({
      "messages": FieldValue.arrayUnion(element),
      "lastMessage": _enteredMessage,
      "lastMessageDate": createdAt,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        border: Border.all(color: Colors.grey),
      ),
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.only(bottom:8, left: 8, right: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: Colors.black),
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                labelText: "Send a message",
                labelStyle: TextStyle(color: Colors.black54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
