import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:question_reminders/models/question.dart';
import 'package:question_reminders/providers/question_provider.dart';
import 'package:question_reminders/widgets/question/question_item.dart';

class QuestionList extends StatefulWidget {
  final String type, selectedFilter, secondType;
  final String lessonName, uid;
  QuestionList(
      {this.type,
      this.selectedFilter,
      this.lessonName,
      this.secondType,
      this.uid});

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.type == "all"
          ? Provider.of<QuestionProvider>(context)
              .fetchAndSetQuestions(widget.selectedFilter, widget.lessonName)
          : Provider.of<QuestionProvider>(context)
              .getQuestionByUserId(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.documents.length == 0) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                widget.type == "all"
                    ? "Bu alanda henüz soru bulunmamaktadır."
                    : "Henüz soru eklemediniz.",
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
            questionDocumentID: docs[index].documentID,
            type: widget.type,
            secondType: widget.secondType,
          ),
        );
      },
    );
  }
}
