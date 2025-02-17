// This class is a singleton
// Because we can't create instance of it more than once

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // this is a private constructor
  DatabaseService._();

  // it is a instance of this class by which we can access this class from another class
  static final database_instance = DatabaseService._();

  // initialized the database
  Database? app_DataBase;

  // database table name , column names

  final String TABLE_NAME = 'NOTE_TABLE_1';
  final String COLUMN_SERIAL_NUMBER = 'SERIAL_NO';
  final String COLUMN_TITLE = 'TITLE';
  final String COLUMN_DESCRIPTION = 'DESCRIPTION';

// get database function
  Future<Database?> getDataBase() async {
    if (app_DataBase != null) {
      return app_DataBase;
    } else {
      app_DataBase = await openDataBase();
      return app_DataBase;
    }
  }

// open database function
  Future<Database> openDataBase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String databasePath = join(appDirectory.path, "AppDB.db");

    // Create all database tables here
    return await openDatabase(databasePath, onCreate: (db, version) {
      db.execute(
          "create table $TABLE_NAME($COLUMN_SERIAL_NUMBER INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_TITLE TEXT, $COLUMN_DESCRIPTION TEXT )");
    }, version: 1);
  }

  // add data to database function
  Future<bool> addData(
      {required String Title, required String Description}) async {
    var db = await getDataBase();

    // insert the data to database
    int rowId = await db!.insert(TABLE_NAME, {
      COLUMN_TITLE: Title,
      COLUMN_DESCRIPTION: Description,
    });

    // Check if the row was inserted by validating the rowId
    return rowId > 0;
  }

  //fetch all data from database function
  Future<List<Map<String, dynamic>>> getAllData() async {
    var db = await getDataBase();

    // fetch all data from database and puts them inside the List named: 'dataList'
    Future<List<Map<String, Object?>>> dataList = db!.query(TABLE_NAME);
//return the list
    return dataList;
  }

  //update the database info function

  Future<bool> updateData(
      {required String Title,
      required String Description,
      required S_no}) async {
    var db = await getDataBase();
    int rowId = await db!.update(
        TABLE_NAME,
        {
          COLUMN_TITLE: Title,
          COLUMN_DESCRIPTION: Description,
        },
        where: "$COLUMN_SERIAL_NUMBER = $S_no");
    return rowId > 0;
  }

  //delete the row function

  Future<bool> deleteData(
      {required S_no}) async {
    var db = await getDataBase();
    int rowId = await db!.delete(TABLE_NAME,
        where: "$COLUMN_SERIAL_NUMBER = ?", whereArgs: ['$S_no']);
    return rowId > 0;
  }
}
