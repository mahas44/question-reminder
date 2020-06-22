import 'package:flutter/material.dart';
import '../widgets/questions.dart';

class ExamLessonsScreen extends StatefulWidget {
  static const routeName = "/exam-lessons";

  @override
  _ExamLessonsScreenState createState() => _ExamLessonsScreenState();
}

class _ExamLessonsScreenState extends State<ExamLessonsScreen> {
  String examTitle;
  bool _loadedInitData = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      final routeArgs = ModalRoute.of(context).settings.arguments as Map;
      examTitle = routeArgs["exam"];
      _loadedInitData = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(examTitle, style: Theme.of(context).textTheme.headline2,),
      ),
      body: Questions(
          type: "all",
          selectedFilter: examTitle,
        ),
    );
  }
}
