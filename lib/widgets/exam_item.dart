import 'package:flutter/material.dart';
import 'package:question_reminders/screens/exam_lessons_screen.dart';

class ExamItem extends StatelessWidget {
  final String exam;
  final Color color;
  final int id;
  ExamItem(this.id, this.exam, this.color);

  void selectExam(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExamLessonsScreen(
          examTitle: exam,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectExam(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          exam,
          style: Theme.of(context).textTheme.headline6,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
