//import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tcg_app_sp/models/userinfo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DataBaseHelper{
  final databaseName = "users.db";
  final collectionDataBaseName = "collection.db";
  String collectionTable = "CREATE TABLE collection (cardID TEXT, user TEXT, cardName TEXT, imgURL TEXT, cardType TEXT, PRIMARY KEY (cardID, user))";
  String userTable = "CREATE TABLE users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE NOT NULL, usrPassword TEXT NOT NULL)";

  Future<Database> initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, databaseName);

    return openDatabase(path, version: 3, onCreate: (db, version) async {
      await db.execute(userTable);
      await db.execute(collectionTable);
    });
  }
  
  Future<bool> login(Users user) async {
    final Database db = await initDB();
    var result = await db.rawQuery("SELECT * from users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'");
    if(result.isNotEmpty){
      return true;
    } else{
      return false;
    }
  }

  Future<int> createUser(Users user) async {
    final Database db = await initDB();
    return db.insert('users', user.toMap());
  }

  Future<bool> getUser(String username) async {
    final Database db = await initDB();
    var result = await db.rawQuery("SELECT * from users where usrName = ?", [username]);
    if(result.isNotEmpty){
      return true;
    } else{
      return false;
    }
  }

  Future<int> deleteUser(String username) async{
    final Database db = await initDB();
    return db.delete('users', where: 'usrName = ?', whereArgs: [username]);
  }

  Future<int> updateUser(String username, String password) async {
    final Database db = await initDB();
    return db.rawUpdate('update users set usrPassword = ? where usrName = ?', [password, username]);
  }
}