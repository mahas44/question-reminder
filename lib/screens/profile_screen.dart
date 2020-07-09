import 'package:flutter/material.dart';
import 'package:question_reminders/widgets/question_list.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = "/profile";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: QuestionList(
          type: "my",
          selectedFilter: "my",
        ),
      ),
    );
  }
}
