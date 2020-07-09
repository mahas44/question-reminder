import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_reminders/colors.dart';
import 'package:question_reminders/constant.dart';
import 'package:question_reminders/models/question.dart';
import 'package:question_reminders/providers/question_provider.dart';
import 'package:question_reminders/widgets/image_input.dart';
import 'package:question_reminders/widgets/my_dropdown_button.dart';
import '../widgets/accent_color_override.dart';

class AddQuestionScreen extends StatefulWidget {
  static const routeName = "/add-question";

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  File _pickedImage;
  final _descriptionController = TextEditingController();

  String _selectedLesson;
  String _selectedExam = Exams.keys.elementAt(0);

  List<String> lessonList = Exams["TYT"];

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectLesson(String selectedLesson) {
    _selectedLesson = selectedLesson;
  }

  void _selectClazz(String selectedExam) {
    _selectedExam = selectedExam;
  }

  void _changeLessonList(String selectedExam) {
    setState(() {
      lessonList = Exams[selectedExam];
      _selectedLesson = lessonList[0];
    });
  }

  var connectionStatus;
  void _saveQuestion(BuildContext context) {
    if (_descriptionController.text.isEmpty || _pickedImage == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Konu metni eklediğinizden ve soru resmini seçtiğinizden emin olun.",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    var dateTime = Timestamp.now().millisecondsSinceEpoch;
    var question = Question(
      id: dateTime.toString(),
      description: _descriptionController.text,
      lesson: _selectedLesson,
      exam: _selectedExam,
      imageFile: _pickedImage,
      dateTime: dateTime,
    );
    Provider.of<QuestionProvider>(context, listen: false).addQuestion(question);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Yeni Soru Ekle"),
        ),
        body: Builder(
          builder: (context) => Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      children: [
                        AccentColorOverride(
                          color: kShrineBrown900,
                          child: TextField(
                            maxLength: 40,
                            decoration: InputDecoration(
                                hintText:
                                    "örn: üçgende açılar, anlatım bozukluğu vs.",
                                labelText: "Konu",
                                border: OutlineInputBorder()),
                            controller: _descriptionController,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MyDropDownButton(
                              Exams.keys.toList(),
                              _selectClazz,
                              true,
                              onChangeLessonList: _changeLessonList,
                            ),
                            MyDropDownButton(
                              lessonList,
                              _selectLesson,
                              false,
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        ImageInput(_selectImage),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: RaisedButton.icon(
                  onPressed: () => _saveQuestion(context),
                  icon: Icon(Icons.add),
                  label: Text("Soru Ekle"),
                  elevation: 8,
                  textColor: Theme.of(context).accentColor,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
