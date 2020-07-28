import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var format = DateFormat("d MMM HH:mm", "tr_TR");

class MessageBubble extends StatelessWidget {
  final String message, username;
  final int createdAt;
  final bool isMe;

  MessageBubble(
    this.message,
    this.username,
    this.createdAt,
    this.isMe,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMe
          ? const EdgeInsets.only(right: 16)
          : const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.green[400] : Colors.blueGrey[500],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: isMe
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.headline6.color,
                  ),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
                Text(
                  format.format(DateTime.fromMillisecondsSinceEpoch(createdAt)),
                  style: TextStyle(
                    fontSize: 12,
                    color: isMe ? Colors.black45 : Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
