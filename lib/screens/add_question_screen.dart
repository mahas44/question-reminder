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

  void _saveQuestion() {
    if (_descriptionController.text.isEmpty || _pickedImage == null) {
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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                  child: Column(
                    children: [
                      AccentColorOverride(
                        color: kShrineBrown900,
                        child: TextField(
                          decoration: InputDecoration(labelText: "Açıklama", border: OutlineInputBorder()),
                          controller: _descriptionController,
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                      SizedBox(
                        height: 10,
                      ),
                      ImageInput(_selectImage),
                    ],
                  ),
                ),
              ),
            ),
            RaisedButton.icon(
              onPressed: _saveQuestion,
              icon: Icon(Icons.add),
              label: Text("Soru Ekle"),
              elevation: 8,
              textColor: Theme.of(context).accentColor,
              materialTapTargetSize: MaterialTapTargetSize.padded,
            ),
          ],
        ),
      ),
    );
  }
}


