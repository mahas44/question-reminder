import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:question_reminders/connectivity_status.dart';
import 'package:question_reminders/models/question.dart';
import 'package:question_reminders/providers/question_provider.dart';
import 'package:question_reminders/widgets/question_item.dart';

class QuestionList extends StatefulWidget {
  final String type, selectedFilter;
  final String lessonName;
  QuestionList({this.type, this.selectedFilter, this.lessonName});

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return connectionStatus != ConnectivityStatus.Offline
        ? FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return StreamBuilder(
                stream: widget.type == "all"
                    ? Provider.of<QuestionProvider>(context)
                        .fetchAndSetQuestions(widget.selectedFilter, widget.lessonName)
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
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    );
                  }
                  final docs = snapshot.data.documents;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (ctx, index) => QuestionItem(
                      question: Question.fromJson(docs[index].data),
                      questionDocumentID: docs[index].documentID,
                      type: widget.type,
                    ),
                  );
                },
              );
            },
          )
        : FutureBuilder(
            future: Provider.of<QuestionProvider>(context)
                .fetchAndSetQuestionsLocal(widget.selectedFilter),
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<QuestionProvider>(
                    child: Center(
                      child: Text("Bu alanda henüz soru bulunmamaktadır"),
                    ),
                    builder: (context, questions, child) =>
                        questions.items.length <= 0
                            ? child
                            : ListView.builder(
                                itemCount: questions.items.length,
                                itemBuilder: (context, index) => QuestionItem(
                                  question: questions.items[index],
                                  questionDocumentID: null,
                                  type: widget.type,
                                ),
                              ),
                  ),
          );
  }
}
