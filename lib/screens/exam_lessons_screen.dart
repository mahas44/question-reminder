import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/connectivity_status.dart';
import 'package:question_reminders/constant.dart';
import 'package:question_reminders/models/lesson.dart';
import '../widgets/question_list.dart';

class ExamLessonsScreen extends StatefulWidget {
  static const routeName = "/exam-lessons";
  final String examTitle;

  ExamLessonsScreen({@required this.examTitle});

  @override
  _ExamLessonsScreenState createState() => _ExamLessonsScreenState();
}

class _ExamLessonsScreenState extends State<ExamLessonsScreen>
    with TickerProviderStateMixin {
  var id = 0;
  var lessonName;
  List<Lesson> lessonList;
  List<Tab> _tabs = List<Tab>();
  TabController _tabController;

  @override
  initState() {
    super.initState();
    lessonList = exams[widget.examTitle];
    lessonName = lessonList.elementAt(id).name;
    for (var i = 0; i < lessonList.length; i++) {
      _tabs.add(
        Tab(text: lessonList.elementAt(i).name),
      );
    }
    _tabController = TabController(length: _tabs.length, vsync: this);
    print(_tabs);
  }

  @override
  dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildRadioButton(Lesson lesson) {
    return Row(
      children: [
        Radio(
          groupValue: id,
          value: lesson.id,
          onChanged: (value) {
            setState(() {
              id = value;
              lessonName = lesson.name;
            });
          },
        ),
        Text("${lesson.name}"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return DefaultTabController(
      length: lessonList.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: lessonList.length <= 3 ? false : true,
            controller: _tabController,
            unselectedLabelColor: kShrineBrown700.withOpacity(0.6),

            tabs: _tabs,
          ),
          title: Text(
            widget.examTitle,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            for (var tab in _tabs)
              connectionStatus != ConnectivityStatus.Offline
                  ? QuestionList(
                      type: "all",
                      selectedFilter: widget.examTitle,
                      lessonName: tab.text,
                    )
                  : Center(
                      child: Text("İnternet bağlantınız kontrol ediniz"),
                    ),
          ],
        ),
        // body: connectionStatus != ConnectivityStatus.Offline
        //     ? Column(
        //         children: [
        //           SingleChildScrollView(
        //             scrollDirection: Axis.horizontal,
        //             padding: EdgeInsets.symmetric(horizontal: 8),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: lessonList
        //                   .map((lesson) => buildRadioButton(lesson))
        //                   .toList(),
        //             ),
        //           ),
        //           Expanded(
        //             child: QuestionList(
        //               type: "all",
        //               selectedFilter: widget.examTitle,
        //               lessonName: lessonName,
        //             ),
        //           ),
        //         ],
        //       )
        //     : Center(
        //         child: Text("İnternet bağlantınız kontrol ediniz"),
        //       ),
      ),
    );
  }
}
