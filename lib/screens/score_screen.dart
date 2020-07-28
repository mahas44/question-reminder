import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'profile_screen.dart';

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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: i == 0
                            ? InkWell(
                                onTap: () {
                                  Map<String, dynamic> data = {
                                    "type": "look",
                                    "userData": docs[i],
                                  };
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(),
                                      settings: RouteSettings(arguments: data),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "${i + 1}.",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
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
                                      width: 16,
                                    ),
                                    Text(
                                      docs[i]["username"],
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    SizedBox(
                                      width: 16,
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
                                              text:
                                                  docs[i]["score"].toString() +
                                                      " Puan"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  Map<String, dynamic> data = {
                                    "type": "look",
                                    "userData": docs[i],
                                  };
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(),
                                      settings: RouteSettings(arguments: data),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
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
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                        Text(docs[i]["username"],
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1),
                                        SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.stars),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            docs[i]["score"].toString() +
                                                " Puan",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
