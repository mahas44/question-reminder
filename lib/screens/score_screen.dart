import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: Firestore.instance
                .collection("users")
                .orderBy("score", descending: true)
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data.documents;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          i == 0
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${i + 1}.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: Image.network(
                                          docs[i]["imageUrl"],
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        docs[i]["username"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                child: Icon(Icons.stars),
                                              ),
                                            ),
                                            TextSpan(
                                                text: "Puan " +
                                                    docs[i]["score"]
                                                        .toString()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${i + 1}.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Image.network(
                                          docs[i]["imageUrl"],
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        docs[i]["username"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                child: Icon(Icons.stars),
                                              ),
                                            ),
                                            TextSpan(
                                                text: "Puan " +
                                                    docs[i]["score"]
                                                        .toString()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      Divider(height: 3, color: Colors.blueGrey)
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
