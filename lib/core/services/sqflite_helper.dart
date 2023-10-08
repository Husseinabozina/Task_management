import 'package:sqflite/sqflite.dart';
import 'package:todoapp/Features/Home/data/model/taskModel.dart';

class SqfliteHelper {
  late Database db;

// create database
  Future<void> initDb() async {
    await openDatabase(
      'tasks.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
      CREATE TABLE Tasks(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      note TEXT,
      date TEXT,
      startTime TEXT,
      endTime TEXT,
      isCompleted INTEGER,
      color INTEGER,
      repeat TEXT
      )
      ''').then((value) => print('database created successfully'));
      },
      onOpen: (db) => print('database opened'),
    ).then((value) => db = value).catchError((e) {
      print(e.toString());
    });
  }

  Future<List<Map<String, Object?>>> getFromDB() async {
    return await db.rawQuery('SELECT * FROM Tasks');
  }

  Future<int> insertToDB(TaskModel taskModel) async {
    return await db.rawInsert(
        '''INSERT INTO Tasks(id ,title ,note ,date ,startTime ,endTime ,isCompleted ,color ,repeat)
     VALUES(${taskModel.id} ,'${taskModel.title}' ,'${taskModel.note}' ,'${taskModel.date}' ,'${taskModel.startTime}'
     ,'${taskModel.endTime}' ,${taskModel.isCompleted} ,${taskModel.color} ,'${taskModel.repeat}')''');
  }

  Future<int> updatedDB(int id) async {
    return await db.rawUpdate(
        '''UPDATE Tasks SET isCompleted = ? WHERE id = ?''', [1, id]);
  }

  Future<int> deleteFromDB(int id) async {
    return await db.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]);
  }
}
