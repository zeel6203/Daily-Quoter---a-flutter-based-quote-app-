import 'package:api_to_sql/data/models/datamodel.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databasename = 'quotes.db';
  static final _databaseVersion = 1;
  static final columnId = 'id';

  DatabaseHelper._createInstance();

  static final DatabaseHelper instance = DatabaseHelper._createInstance();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databasename);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE quotes (
    id TEXT PRIMARY KEY,
        content TEXT,
        author TEXT,
        tags TEXT,
        authorSlug TEXT,
        length INTEGER,
        dateAdded TEXT,
        dateModified TEXT)''');
  }

  Future<int?> insert(datamodel quote) async {
    final db = await database;
    print({
      "id": quote?.id.toString(),
      "content": quote?.content.toString(),
      "author": quote?.author.toString(),
      "length": quote?.length,
      "tags": quote?.tags?.join(",")
    });

    int? id = await db?.insert('quotes', quote!.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<datamodel>> fetchSavedQuotes({texttofind = ""}) async {
    final db = await database;
    final results = await db.query("quotes");
    print("fetched $results");
    var resultinlist = List.generate(results.length, (index) {
      return datamodel.fromJsonfordatabase(results[index]);
    });
    print("list ____ : $resultinlist");
    // return resultinlist;
    List<datamodel> finalresultlist = [];
    for (datamodel item in resultinlist) {
      print(item.tags);
      if (item.content.toLowerCase().contains(texttofind.toLowerCase()) ||
          item.author.toLowerCase().contains(texttofind.toLowerCase()) ||
          item.tags
              .toString()
              .toLowerCase()
              .contains(texttofind.toLowerCase())) {
        finalresultlist.add(item);
      }
    }
    return finalresultlist;
    // return List.generate(results.length, (index) {
    //   return datamodel.fromJsonforread(results[index]);
    // });
  }

  Future<int> delete(String id) async {
    Database db = await instance.database;
    return await db.delete("quotes", where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update (datamodel quote) async {
    Database db = await instance.database;
    String id= quote.id;
    return await db.update("quotes",quote.toJson(),where: "$columnId = ?",whereArgs: [id]);


  }

}
