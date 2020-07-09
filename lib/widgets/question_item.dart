import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/connectivity_status.dart';
import 'package:question_reminders/constant.dart';
import 'package:question_reminders/models/question.dart';
import 'package:question_reminders/providers/question_provider.dart';
import 'package:question_reminders/widgets/comment_list.dart';
import '../helpers/notification_manager.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:io';

class QuestionItem extends StatefulWidget {
  final Question question;
  final String questionDocumentID;
  final String type;
  QuestionItem({
    this.question,
    this.questionDocumentID,
    this.type,
  });

  @override
  _QuestionItemState createState() => _QuestionItemState();
}

class _QuestionItemState extends State<QuestionItem> {
  double cardHeight = 400;
  var connectionStatus;
  File _storedImage;

  Future<void> _takePicture(String sourceType) async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: sourceType == "kamera" ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 600, // auto crop image width
      maxHeight: 800,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });

    Provider.of<QuestionProvider>(context, listen: false)
        .addQuestionResult(widget.questionDocumentID, _storedImage);
  }

  Future showDialogForImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Resim Seçimi"),
          content: Text("Resmi nereden seçmek istersiniz?"),
          actions: [
            FlatButton.icon(
              icon: Icon(Icons.add_photo_alternate),
              label: Text("Galeri"),
              onPressed: () {
                _takePicture("galeri");
                Navigator.of(context).pop();
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text("Kamera"),
              onPressed: () {
                _takePicture("kamera");
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _showComments(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: CommentList(widget.question.id, widget.questionDocumentID),

          // : CommentListLocal(widget.question.id),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addAlarm() async {
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
        Provider.of<QuestionProvider>(context, listen: false)
            .updateQuestion(widget.questionDocumentID, {
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
    return SizedBox(
      width: 100,
      child: FlatButton(
        child: Text(
          "Yorumları göster",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        onPressed: () => connectionStatus == ConnectivityStatus.Offline
            ? showAlertDialog()
            : _showComments(context),
      ),
    );
  }

  Future showAlertDialog() {
    return showDialog(
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
  }

  bool _alarmCheck() {
    if (widget.question.isAlarmActive && widget.type == "my") {
      if (DateTime.now().millisecondsSinceEpoch <= widget.question.alarmDate) {
        return true;
      }
      return false;
    }
    return false;
  }

  Future deleteShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alert Dialog"),
          content: Text("Bu soruyu silmek istedğinizden emin misiniz ?"),
          actions: [
            FlatButton(
              child: Text("Hayır"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text("Evet"),
              onPressed: () {
                Provider.of<QuestionProvider>(context, listen: false)
                    .deleteQuestion(widget.questionDocumentID);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    connectionStatus = Provider.of<ConnectivityStatus>(context);
    cardHeight = MediaQuery.of(context).size.height * 0.7;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlipCard(
        front: Container(
          height: cardHeight,
          child: buildFrontCard(context),
        ),
        back: buildBackCard(),
      ),
    );
  }

  Widget image(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.antiAlias,
      child: connectionStatus == ConnectivityStatus.Offline
          ? Image.memory(
              widget.question.imageFile.readAsBytesSync(),
              width: double.infinity,
              fit: BoxFit.fill,
            )
          : Image.network(
              widget.question.imageUrl,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
    );
  }

  Widget buildBackCard() {
    return Container(
      height: cardHeight,
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: widget.question.resultImageUrl != null
              ? Image.network(
                  widget.question.resultImageUrl,
                  width: double.infinity,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  "assets/icon.png",
                  width: double.infinity,
                ),
        ),
      ),
    );
  }

  GridTile buildFrontCard(BuildContext context) {
    return GridTile(
      footer: Material(
        color: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(4),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: buildGridTileBar(context),
      ),
      child: image(context),
    );
  }

  GridTileBar buildGridTileBar(BuildContext context) {
    return GridTileBar(
        backgroundColor: Colors.black45,
        title: Column(
          children: <Widget>[
            if (widget.type == "all")
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.question.creatorUsername,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            gridTitleText(
                "${widget.question.exam} / ${widget.question.lesson}"),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            gridTitleText(widget.question.description),
            if (_alarmCheck())
              Row(
                children: <Widget>[
                  gridTitleText(
                    format.format(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.question.alarmDate),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.alarm,
                    size: 16,
                  )
                ],
              ),
          ],
        ),
        trailing: Row(
          children: <Widget>[
            _flatButton(),
            if (widget.type == "my") menuItem(context),
          ],
        ));
  }

  Widget menuItem(BuildContext context) {
    return PopupMenuButton<String>(
      color: kShrinePink400,
      padding: EdgeInsets.zero,
      onSelected: (value) {
        switch (value) {
          case "Sil":
            deleteShowDialog(context);
            break;
          case "Alarm Ekle":
            _addAlarm();
            break;
          case "Cevap Ekle":
            showDialogForImage(context);
            break;
          default:
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: "Alarm Ekle",
          child: ListTile(
            leading: const Icon(Icons.add_alert),
            title: Text("Alarm Ekle"),
          ),
        ),
        PopupMenuItem(
          value: "Cevap Ekle",
          child: ListTile(
            leading: const Icon(Icons.question_answer),
            title: Text("Cevap Ekle"),
          ),
        ),
        PopupMenuItem(
          value: "Sil",
          child: ListTile(
            leading: const Icon(Icons.delete_forever),
            title: Text("Sil"),
          ),
        ),
      ],
    );
  }

  Widget gridTitleText(text) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(text),
    );
  }
}
