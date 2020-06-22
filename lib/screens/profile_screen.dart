import 'package:flutter/material.dart';
import 'package:question_reminders/widgets/questions.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Questions(
          type: "my",
          selectedFilter: "my",
        ),
      ),
    );
  }
}
