import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/connectivity_status.dart';
import 'package:question_reminders/models/lesson.dart';
import 'package:question_reminders/providers/constant_provider.dart';
import '../widgets/question/question_list.dart';

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

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      lessonList = Provider.of<ConstantProvider>(context, listen: false)
          .lessons[widget.examTitle];
      lessonName = lessonList.elementAt(id).name;
      for (var i = 0; i < lessonList.length; i++) {
        _tabs.add(
          Tab(text: lessonList.elementAt(i).name),
        );
      }
      _tabController = TabController(length: _tabs.length, vsync: this);
    }
    _isInit = false;
  }

  @override
  dispose() {
    _tabController.dispose();
    super.dispose();
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
          centerTitle: true,
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
