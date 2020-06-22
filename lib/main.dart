import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/helpers/custom_route.dart';
import 'package:question_reminders/providers/comment_provider.dart';
import 'package:question_reminders/providers/question_provider.dart';
import 'package:question_reminders/screens/add_question_screen.dart';
import 'package:question_reminders/screens/auth_screen.dart';
import 'package:question_reminders/screens/exam_lessons_screen.dart';
import 'package:question_reminders/screens/tabs_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => QuestionProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CommentProvider(),
        )
        // (ctx) => QuestionProvider()
      ],
      child: MaterialApp(
        title: 'Question Reminder',
        theme: ThemeData(
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
                headline2: TextStyle(fontSize: 20, color: kShrineBrown900),
                headline3: TextStyle(fontSize: 12, color: kShrineBrown500),
                headline4: TextStyle(fontSize: 14, color: kShrinePink900, fontWeight: FontWeight.bold),
                bodyText1: TextStyle(fontSize: 16, color: kShrineBrown900),
                bodyText2: TextStyle(fontSize: 14, color: kShrineBrown500),
              ),
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
          ExamLessonsScreen.routeName: (ctx) => ExamLessonsScreen(),
        },
      ),
    );
  }
}
