import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/screens/add_question_screen.dart';
import 'package:question_reminders/screens/home_screen.dart';
import 'package:question_reminders/screens/profile_screen.dart';



class TabsScreen extends StatefulWidget {

  static const routeName = "/tabs";

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;



  @override
  void initState() {
    super.initState();

    _pages = [
      {
        "page": HomeScreen(),
        "title": "Anasayfa",
      },
      {
        "page": ProfileScreen(),
        "title": "Profil",
      }
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]["title"], style: Theme.of(context).textTheme.headline2,),
        actions: [
          _pages[_selectedPageIndex]["title"] == "Profil"
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AddQuestionScreen.routeName);
                  },
                ):
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: _pages[_selectedPageIndex]["page"],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: kShrineBrown900,
        unselectedItemColor: kShrineBrown400,
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.home),
            title: Text("Anasayfa"),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.person),
            title: Text("Profil"),
          ),
        ],
      ),
    );
  }
}
