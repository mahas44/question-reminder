import 'package:flutter/material.dart';
import 'package:question_reminders/constant.dart';
import '../widgets/exam_item.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(20),
      children: DUMMY_EXAM
          .map((data) => ExamItem(
                data.id,
                data.title,
                data.color,
              ))
          .toList(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1.6,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
