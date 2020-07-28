import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/connectivity_status.dart';
import 'package:question_reminders/helpers/connectivity_helper.dart';
import 'package:question_reminders/helpers/custom_route.dart';
import 'package:question_reminders/providers/chat_provider.dart';
import 'package:question_reminders/providers/comment_provider.dart';
import 'package:question_reminders/providers/constant_provider.dart';
import 'package:question_reminders/providers/question_provider.dart';
import 'package:question_reminders/providers/user_provider.dart';
import 'package:question_reminders/screens/add_question_screen.dart';
import 'package:question_reminders/screens/auth_screen.dart';
import 'package:question_reminders/screens/chat_list_screen.dart';
import 'package:question_reminders/screens/home_screen.dart';
import 'package:question_reminders/screens/settings_screen.dart';
import 'package:question_reminders/screens/tabs_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr');
    return StreamProvider<ConnectivityStatus>(
      create: (context) =>
          ConnectivityHelper().connectionStatusController.stream,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => QuestionProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => CommentProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ConstantProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ChatProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Question Reminder',
          theme: ThemeData(
            fontFamily: "OpenSans",
            primaryColor: kShrinePink100,
            accentColor: kShrineBrown900,
            buttonTheme: ThemeData.light().buttonTheme.copyWith(
                buttonColor: kShrinePink500,
                colorScheme: ThemeData.light().colorScheme.copyWith(
                      secondary: kShrineBrown900,
                    )),
            primaryIconTheme:
                ThemeData.light().iconTheme.copyWith(color: kShrineBrown900),
            cardColor: kShrinePink50,
            textSelectionColor: kShrinePink400,
            errorColor: kShrineErrorRed,
            textTheme: ThemeData.light().textTheme.copyWith(
                caption: TextStyle(color: kShrineBrown500),
                subtitle1: TextStyle(color: kShrinePink700),
                headline5: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
                headline6: TextStyle(color: kShrineBrown900),
                bodyText1: TextStyle(color: kShrineBrown900),
                subtitle2: TextStyle(color: kShrinePink500)),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {TargetPlatform.android: CustomPageTransitionBuilder()},
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TabsScreen();
              }
              return AuthScreen();
            },
          ),
          routes: {
            TabsScreen.routeName: (ctx) => TabsScreen(),
            AddQuestionScreen.routeName: (ctx) => AddQuestionScreen(),
            //ProfileScreen.routeName: (ctx) => ProfileScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            ChatListScreen.routeName: (ctx) => ChatListScreen(),
          },
        ),
      ),
    );
  }
}
