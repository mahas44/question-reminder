import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/providers/constant_provider.dart';
import '../widgets/exam_item.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";
  @override
  Widget build(BuildContext context) {
    var examList = Provider.of<ConstantProvider>(context).examList;
    return GridView.count(
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 3/2,
      crossAxisCount: 2,
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      children: examList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : examList
              .map((data) => ExamItem(
                    data.id,
                    data.title,
                    data.color,
                  ))
              .toList(),
    );
    // return GridView(
    //   padding: const EdgeInsets.all(20),
    //   children: examList == null
    //       ? Center(
    //           child: CircularProgressIndicator(),
    //         )
    //       : examList
    //           .map((data) => ExamItem(
    //                 data.id,
    //                 data.title,
    //                 data.color,
    //               ))
    //           .toList(),
    //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //     maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
    //     childAspectRatio: MediaQuery.of(context).size.height / MediaQuery.of(context).size.width,
    //     crossAxisSpacing: 10,
    //     mainAxisSpacing: 10,
    //   ),
    // );
  }
}
