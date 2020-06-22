import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/constant.dart';
import 'package:question_reminders/models/question.dart';
import 'package:question_reminders/widgets/comment_list.dart';
import '../helpers/notification_manager.dart';
import 'package:flip_card/flip_card.dart';

class QuestionItem extends StatefulWidget {
  final Question question;
  final String questionId;
  final String type;
  QuestionItem({
    this.question,
    this.questionId,
    this.type,
  });

  @override
  _QuestionItemState createState() => _QuestionItemState();
}

class _QuestionItemState extends State<QuestionItem> {
  final GlobalKey _cardKey = GlobalKey();
  Size cardSize;
  double cardHeight = 250;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.scheduleFrameCallback((_) => getSize());
  }

  void getSize() {
    RenderBox _cardBox = _cardKey.currentContext.findRenderObject();
    cardSize = _cardBox.size;
    setState(() {
      cardHeight = cardSize.height;
    });
  }

  void _showComments(BuildContext ctx) {
    showModalBottomSheet(
      enableDrag: true,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: CommentList(widget.questionId),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _submit() async {
    NotificationManager notificationManager = NotificationManager();

    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 365)))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      showTimePicker(context: context, initialTime: TimeOfDay.now())
          .then((pickedTime) {
        int hour = pickedTime.hour;
        int minute = pickedTime.minute;
        var dateTime = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, hour, minute);
        Firestore.instance
            .collection("questions")
            .document(widget.questionId)
            .updateData({
          "isAlarmActive": true,
          "alarmDate": dateTime.millisecondsSinceEpoch,
        });
        notificationManager.showNotifitions(
            dateTime.millisecond,
            "${widget.question.exam} / ${widget.question.lesson}",
            widget.question.description,
            dateTime);
      });
    });
  }

  Widget _flatButton() {
    return FlatButton(
      child: Text(
        "Yorumları göster",
        textAlign: TextAlign.end,
        style: TextStyle(color: kShrinePink900, fontSize: 14),
      ),
      onPressed: () => _showComments(context),
    );
  }

  bool _alarmCheck() {
    if (widget.question.isAlarmActive == 1 && widget.type == "my") {
      if (DateTime.now().millisecondsSinceEpoch <= widget.question.alarmDate) {
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: Card(
        key: _cardKey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                widget.question.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Text(
                          widget.question.lesson,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).accentColor),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          widget.question.exam,
                          style: Theme.of(context).textTheme.bodyText1
                        ),
                      ),
                      _flatButton()
                    ],
                  ),
                  if (widget.type == "my")
                  Container(
                    height: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton.icon(
                          label: Text(""),
                          icon: Icon(Icons.add_alert, color: kShrinePink900,),
                          onPressed: _submit,
                        ),
                        if (_alarmCheck())
                          FlatButton.icon(
                            icon: Icon(Icons.alarm_on),
                            label: Text(
                              format.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    widget.question.alarmDate),
                              ),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            onPressed: null,
                          ),
                        FlatButton.icon(
                          label: Text(""),
                          icon: Icon(Icons.delete_forever, color: kShrinePink900,),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Text(
                      widget.question.description,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      back: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            widget.question.imageUrl,
            height: cardHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
