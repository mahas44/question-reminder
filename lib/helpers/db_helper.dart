import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, "question_reminders.db"),
      onCreate: (db, version) {
        db.execute("CREATE TABLE questions" +
            "(id TEXT PRIMARY KEY, description TEXT, imageUrl TEXT," +
            "lesson TEXT, exam TEXT, dateTime INTEGER," +
            "isAlarmActive INTEGER, alarmDate INTEGER, imageFile TEXT," +
            "creatorId TEXT, creatorUsername TEXT, resultImageUrl TEXT, resultFile TEXT)");
        db.execute("CREATE TABLE comments" +
            "(id INTEGER PRIMARY KEY,  comment TEXT, createdAt INTEGER," +
            "createdBy TEXT, creatorUsername TEXT, score INTEGER, questionId TEXT)");
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getCommentByQuestionId(
      String table, String questionId) async {
    final db = await DBHelper.database();
    return db.query(
      table,
      where: "questionId = ?",
      whereArgs: [questionId],
    );
  }
}
