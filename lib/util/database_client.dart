import 'dart:io';
import 'package:dotConnect/model/user_items.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  final String table1 = "User";
  final String table2 = "Profile";
  final String table3 = "Connection";
  final String table4 = "Uploads";
  final String columnId = "id";
  final String columnUsername = "username";
  final String columnPassword = "Password";
  final String columnEmail="email";
  final String columnFullname="fullname";
  final String columnGender="gender";
  final String columnDob="DOB";
  final String columnPhone="phone";
  final String columnConnection = "connection";
  final String columnImage = "profile_pic";
  final String columnUploadImage = "upload_image";
  final String columnText = "upload_text";
  final String columnTime = "upload_time";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "dotConnect.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $table1($columnId INTEGER, $columnUsername TEXT PRIMARY KEY, $columnPassword TEXT, $columnEmail TEXT)");
    await db.execute(
      "CREATE TABLE $table2($columnId INTEGER, $columnUsername TEXT, $columnFullname TEXT, $columnGender TEXT, $columnDob TEXT, $columnImage TEXT, "
          "FOREIGN KEY ($columnUsername) REFERENCES $table1($columnUsername) ON DELETE CASCADE,"
          "PRIMARY KEY($columnUsername))");
    await db.execute(
        "CREATE TABLE $table3($columnId INTEGER, $columnUsername TEXT, $columnConnection TEXT, "
            "FOREIGN KEY ($columnUsername) REFERENCES $table1($columnUsername) ON DELETE CASCADE,"
            "FOREIGN KEY ($columnConnection) REFERENCES $table1($columnUsername) ON DELETE CASCADE,"
            "PRIMARY KEY($columnUsername,$columnConnection))");
    await db.execute(
      "CREATE TABLE $table4($columnId INTEGER PRIMARY KEY, $columnUsername TEXT, $columnText TEXT, $columnTime TEXT, $columnUploadImage TEXT, "
          "FOREIGN KEY ($columnUsername) REFERENCES $table1($columnUsername) ON DELETE CASCADE"
          ")");
    print("Table is created");
  }

 //insertion
  Future<int> saveItem(user_item item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$table1", item.toMap());
    print(res.toString());
    return res;
  }


  Future<int> saveProfile(profile_item item) async{
    var dbClient = await db;
    int res=await dbClient.insert("$table2", item.toMap());
    print(res.toString());
    return res;
  }

  Future<int> saveConnection(connections item) async{
    var dbClient = await db;
    int res = await dbClient.insert("$table3", item.toMap());
    print(res.toString());
    return res;
  }

  Future<int> saveUploadData(Uploads item) async{
    var dbClient = await db;
    int res = await dbClient.insert("$table4", item.toMap());
    print(res.toString());
    return res;
  }

  //Get
  Future<List> getItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table1 ORDER BY $columnUsername ASC"); //ASC

    return result.toList();

//    if (result.length == 0) return [];
//    var users = [];
//
//    for (Map<String, dynamic> map in result) {
//       users.add(new User.fromMap(map));
//    }
//
//    return users;

  }


  Future<profile_item> getProfile(String username) async{
    var dbClient = await db;
    var res= await dbClient.rawQuery("SELECT  * FROM $table2 WHERE $columnUsername=?",[username]);
    if(res.length == 0) return null;
    return new profile_item.fromMap(res.first);
  }

  //count of items
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $table1"
    ));
  }

  //
  Future<user_item> getItem(String username) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table1 WHERE $columnUsername = ?",[username]);
    if (result.length == 0) return null;
    return new user_item.fromMap(result.first);
  }

  Future<List> searchItem(String username, String pattern) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table1 WHERE $columnUsername LIKE ? and $columnUsername != ?",["%$pattern%",username]);
//    var result = await dbClient.query(
//        "$table1",
//        where: "$columnUsername LIKE '%?%'",
//        whereArgs: [username]
//    );
//    var result = await dbClient.rawQuery("SELECT * FROM Companies WHERE name LIKE '%?%';", [username]);
    if (result.length == 0) return null;
    var users = [];
    for (Map<String, dynamic> map in result) {
       users.add(new user_item.fromMap(map));
    }

    return users;
  }

  Future<List> getConnections(String username) async{
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table3 WHERE $columnUsername = ?",[username]);
    if(result.length==0) return null;
    var users=[];
    for (Map<String, dynamic> map in result) {
      users.add(new connections.fromMap(map));
    }
    return users;
  }

  Future<List> getUploads(String username) async{
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $table4 WHERE $columnUsername = ? ORDER BY $columnId DESC",[username]);
    if(res.length == 0) return null;
    var uploads=[];
    for (Map<String, dynamic> map in res) {
      uploads.add(new Uploads.fromMap(map));
    }
    return uploads;
  }

  Future<List> getAllUploads(String username) async{
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT u.$columnId, u.$columnUsername , $columnText , $columnTime , $columnUploadImage , $columnImage"
        " FROM $table4 u, $table2 p WHERE u.$columnUsername IN (SELECT $columnConnection FROM $table3 WHERE $columnUsername =?) and u.$columnUsername = p.$columnUsername "
        "ORDER BY u.$columnId DESC",[username]);
    if(res.length == 0) return null;
    var uploads =[];
    for (Map<String, dynamic> map in res) {
      uploads.add(map);
    }
    return uploads;

  }


  Future<int> getConnectionCount(String username) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $table3 WHERE $columnUsername = ?",[username]
    ));
  }

  Future<user_item> allowItem(String username,String password) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $table1 WHERE $columnUsername = ? and $columnPassword = ?",[username,password]);
    if (result.length == 0) return null;
    return new user_item.fromMap(result.first);
  }

  //deletion
//  Future<int> deleteItem(int id) async {
//    var dbClient = await db;
//    var result = await dbClient.rawQuery("DELETE FROM $tableName WHERE id = $id");
//    if (result.length == 0) return null;
//    return result.first as int;
//  }

  Future<int> deleteItem(String username) async {
    var dbClient = await db;
    return await dbClient.delete(table1,
        where: "$columnUsername = ?", whereArgs: [username]);

  }

  Future<int> deleteConnection(String username,String connection) async{
    var dbClient = await db;
    return await dbClient.delete(
      table3,
      where: "$columnUsername = ? and $columnConnection = ?", whereArgs: [username,connection]
    );
  }

  Future<int> deleteUpload(String username,int id) async{
    var dbClient = await db;
    return await dbClient.delete(
        table4,
        where: "$columnUsername = ? and $columnId = ?", whereArgs: [username,id]
    );
  }

  Future<int> updateItem(user_item item) async {
    var dbClient = await db;
    return await dbClient.update("$table1", item.toMap(),
        where: "$columnUsername = ?", whereArgs: [item.username]);

  }
  
  Future<int> updateProfileData(String username,String fullname, String gender, String dob) async{
    var dbClient = await db;
    Map<String,dynamic> row = {
      columnFullname : fullname,
      columnGender: gender,
      columnDob: dob
    };
    return await dbClient.update("$table2", row,
        where: "$columnUsername = ?",whereArgs: [username]);
  }

  Future<int> updateProfilePicture(String username,String image) async{
    var dbClient = await db;
    Map<String,dynamic> row = {
      columnImage : image
    };
    return await dbClient.update("$table2", row, where: "$columnUsername = ?", whereArgs: [username]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}