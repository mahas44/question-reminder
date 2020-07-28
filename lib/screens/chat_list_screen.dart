import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/providers/user_provider.dart';
import 'package:question_reminders/screens/chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  static const String routeName = "/chat-list";

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserProvider>(context, listen: false).userId;
    List<String> list = List<String>();
    Map<String, String> map = Map();
    return Scaffold(
      body: FutureBuilder(
        future: Firestore.instance
            .collection("chats")
            .where("peers", arrayContains: uid)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            list.clear();
            map.clear();
            final docs = snapshot.data.documents;
            for (var doc in docs) {
              final l = doc.data["peers"] as List;

              l.remove(uid);
              for (var item in l) {
                list.add(item);
                map.putIfAbsent(item.toString().trim(),
                    () => doc.documentID.toString().trim());
              }
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 2,
                color: Theme.of(context).primaryColor,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: Firestore.instance
                      .collection("users")
                      .document(list[index].trim())
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListTile(
                        title: Text(snapshot.data["username"]),
                        subtitle: Text(docs[index]["lastMessage"]),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data["imageUrl"]),
                        ),
                        trailing: Icon(Icons.forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                chatRoomId: map[snapshot.data.documentID],
                                idTo: snapshot.data.documentID,
                                receiverUserdata : snapshot.data,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),

      // StreamBuilder(
      //   stream: Firestore.instance
      //       .collection("chats")
      //       .where("ids", arrayContains: uid)
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else {
      //       final docs = snapshot.data.documents;
      //       for (var item in docs) {
      //         final l = item.data["ids"] as List;
      //         l.remove(uid);
      //         for (var item in l) {
      //           list.add(item);
      //         }
      //       }
      //       print(list);
      //       return ListView.builder(
      //         padding: EdgeInsets.all(10.0),
      //         itemCount: list.length,
      //         itemBuilder: (context, index) {
      //           return Text(list[index]);
      //         },
      //       );
      //     }
      //   },
      // ),
    );
  }
}
