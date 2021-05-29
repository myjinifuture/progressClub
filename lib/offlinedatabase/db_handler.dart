import 'package:path_provider/path_provider.dart';
import 'package:progressclubsurat_new/Common/ClassList.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';



class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'eventvisitor.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE eventvisitor (id INTEGER PRIMARY KEY,name TEXT,mobileNumber TEXT,memberId TEXT)');
  }

  Future<Visitorclass> add(Visitorclass visitor) async {
    var dbClient = await db;
    visitor.id = await dbClient.insert('eventvisitor', visitor.toMap());
    return visitor;
  }

  Future<List<Visitorclass>> getVisitors() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('eventvisitor', columns: ['id', 'name','mobileNumber','memberId']);
    List<Visitorclass> visitors = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        visitors.add(Visitorclass.fromMap(maps[i]));
      }
    }
    return visitors;
  }

  Future<int> delete() async {
    var dbClient = await db;
    return await dbClient.delete(
      'eventvisitor'
    );
  }

}

