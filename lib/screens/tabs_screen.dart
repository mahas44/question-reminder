import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/connectivity_status.dart';
import 'package:question_reminders/screens/add_question_screen.dart';
import 'package:question_reminders/screens/home_screen.dart';
import 'package:question_reminders/screens/profile_screen.dart';
import 'package:question_reminders/screens/score_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = "/tabs";

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  int _selectedPageIndex = 0;

  final List<Tab> tabs = [
    Tab(text: "Anasayfa"),
    Tab(text: "Skor Tablosu"),
    Tab(text: "Profil"),
  ];
  TabController _tabController;
  final List<Widget> screens = [
    HomeScreen(),
    ScoreScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_handleTabSection);
  }

  _handleTabSection() {
    setState(() {
      _selectedPageIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  static final centerLocations = <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kShrinePink300,
          automaticallyImplyLeading: false,
          title: Text(
            tabs.elementAt(_tabController.index).text,
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: [
            tabs.elementAt(_selectedPageIndex).text == "Profil"
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () =>
                        addQuestionButton(context, connectionStatus),
                  )
                : IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: screens.map((item) {
            return item;
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => addQuestionButton(context, connectionStatus),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: kShrinePink400,
          shape: CircularNotchedRectangle(),
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).accentColor),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    _tabController.index = 0;
                  },
                ),
                if (centerLocations
                    .contains(FloatingActionButtonLocation.centerDocked))
                  const Spacer(),
                IconButton(
                  icon: const Icon(Icons.score),
                  onPressed: () {
                    _tabController.index = 1;
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    _tabController.index = 2;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addQuestionButton(BuildContext context, connectionStatus) {
    if (connectionStatus == ConnectivityStatus.Offline) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Bağlantı Sorunu"),
            content: Text(
                "İnternet bağlantınızı kontrol ediniz. Bir ağa bağlı olabilirsiniz ama internet erişiminiz olmayabilir."),
            actions: [
              FlatButton(
                child: Text("Kapat"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    } else {
      Navigator.of(context).pushNamed(AddQuestionScreen.routeName);
    }
  }
}
