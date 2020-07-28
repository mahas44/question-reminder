import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/connectivity_status.dart';
import 'package:question_reminders/providers/constant_provider.dart';
import 'package:question_reminders/providers/user_provider.dart';
import 'package:question_reminders/screens/add_question_screen.dart';
import 'package:question_reminders/screens/chat_list_screen.dart';
import 'package:question_reminders/screens/home_screen.dart';
import 'package:question_reminders/screens/profile_screen.dart';
import 'package:question_reminders/screens/score_screen.dart';
import 'package:question_reminders/screens/settings_screen.dart';

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
    Tab(text: "Sohbetler"),
    Tab(text: "Skor Tablosu"),
    Tab(text: "Profil"),
  ];
  TabController _tabController;
  final List<Widget> screens = [
    HomeScreen(),
    ChatListScreen(),
    ScoreScreen(),
    ProfileScreen(),
  ];

  void getData() async {
    await Provider.of<ConstantProvider>(context, listen: false)
        .getExams()
        .then((value) {
      Provider.of<ConstantProvider>(context, listen: false).lessonList();
      Provider.of<ConstantProvider>(context, listen: false).examObjectList();

      Provider.of<UserProvider>(context, listen: false).getUserId().then((_) =>
          Provider.of<UserProvider>(context, listen: false).getUserData());
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_handleTabSection);
    _tabController.index = _selectedPageIndex;

    // getData();
  }

  var _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ConstantProvider>(context, listen: false)
          .getExams()
          .then((value) {
        Provider.of<ConstantProvider>(context, listen: false).lessonList();
        Provider.of<ConstantProvider>(context, listen: false).examObjectList();

        Provider.of<UserProvider>(context, listen: false).getUserId().then(
            (_) => Provider.of<UserProvider>(context, listen: false)
                .getUserData());
      });
    }
    _isInit = false;
    super.didChangeDependencies();
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

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          // centerTitle: true,
          backgroundColor: kShrinePink300,
          automaticallyImplyLeading: false,
          title: Text(
            tabs.elementAt(_tabController.index).text,
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: [
            menuItem(context, connectionStatus),
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
          notchMargin: 0,
          color: kShrinePink400,
          shape: CircularNotchedRectangle(),
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).accentColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.home),
                    color: _tabController.index == 0
                        ? Colors.teal
                        : Theme.of(context).accentColor,
                    onPressed: () {
                      _tabController.index = 0;
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat),
                    color: _tabController.index == 1
                        ? Colors.teal
                        : Theme.of(context).accentColor,
                    onPressed: () {
                      _tabController.index = 1;
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.score),
                    color: _tabController.index == 2
                        ? Colors.teal
                        : Theme.of(context).accentColor,
                    onPressed: () {
                      _tabController.index = 2;
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: const Icon(Icons.person),
                    color: _tabController.index == 3
                        ? Colors.teal
                        : Theme.of(context).accentColor,
                    onPressed: () {
                      _tabController.index = 3;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget menuItem(BuildContext context, connectionStatus) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      onSelected: (value) {
        switch (value) {
          case "Add":
            addQuestionButton(context, connectionStatus);
            break;
          case "Settings":
            Navigator.of(context).pushNamed(SettingsScreen.routeName);
            break;
          case "Logout":
            // _isInit = true;
            Provider.of<ConstantProvider>(context, listen: false).clear();
            FirebaseAuth.instance.signOut();
            break;
          default:
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
            value: "Add",
            child: Row(
              children: <Widget>[
                Icon(Icons.add),
                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Text("Soru Ekle")
              ],
            )),
        PopupMenuItem(
            value: "Settings",
            child: Row(
              children: <Widget>[
                Icon(Icons.settings),
                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Text("Ayarlar")
              ],
            )),
        PopupMenuItem(
            value: "Logout",
            child: Row(
              children: <Widget>[
                Icon(Icons.exit_to_app),
                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Text("Çıkış")
              ],
            )),
      ],
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
