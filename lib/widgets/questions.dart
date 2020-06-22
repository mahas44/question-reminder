import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:question_reminders/models/question.dart';
import 'package:question_reminders/providers/question_provider.dart';
import 'package:question_reminders/widgets/question_item.dart';

class Questions extends StatelessWidget {
  final String type, selectedFilter;
  Questions({this.type, this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: type == "all"
              ? Provider.of<QuestionProvider>(context)
                  .fetchAndSetPlaces(selectedFilter)
              : Provider.of<QuestionProvider>(context)
                  .getQuestionByUserId(snapshot.data.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Bu alanda henüz soru bulunmamaktadır.",
                    style: Theme.of(context).textTheme.bodyText1,

                  ),
                ),
              );
            }
            final docs = snapshot.data.documents;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (ctx, index) => QuestionItem(
                question: Question.fromJson(docs[index].data),
                questionId: docs[index].documentID,
                type: type,
              ),
            );
          },
        );
      },
    );
  }
}
