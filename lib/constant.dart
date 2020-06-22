import 'package:question_reminders/colors.dart';
import 'package:question_reminders/models/exam.dart';
import 'package:intl/intl.dart';

var format = DateFormat("d MMM y HH:mm", "tr_TR");

const DUMMY_EXAM = const [
  Exam(id: 0, title: "LGS", color: kShrinePink300),
  Exam(id: 1, title: "TYT", color: kShrinePink400),
  Exam(id: 2, title: "AYT - Sözel", color: kShrinePink500),
  Exam(id: 3, title: "AYT - Sayısal", color: kShrinePink600),
  Exam(id: 4, title: "DGS", color: kShrinePink700),
  Exam(id: 5, title: "ALES", color: kShrinePink800),
  Exam(id: 7, title: "KPSS", color: kShrinePink900),
];

const Lessons = [
  'Matematik',
  'Geometri',
  'Fizik',
  'Kimya',
  "Biyoloji",
  "Coğrafya",
  "Tarih",
  "Türkçe",
  "Edebiyat",
];

const Exams = {
  "LGS": [
    "Türkçe",
    "Sosyal Bilimler",
    "Matematik",
    "Fen Bilimleri",
  ],
  "TYT": [
    "Türkçe",
    "Sosyal Bilimler",
    "Matematik",
    "Fen Bilimleri",
  ],
  "AYT - Sözel": [
    "Türk Dili ve Edebiyatı",
    "Tarih",
    "Coğrafya",
    "Felsefe",
    "Din Kültürü",
  ],

  "AYT - Sayısal": [
    "Matematik",
    "Geometri",
    "Fizik",
    "Kimya",
    "Biyoloji",
  ],
  "DGS": [
    "Türkçe",
    "Matematik",
  ],
  "ALES": [
    "Türkçe",
    "Matematik",
  ]
};
