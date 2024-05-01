import 'package:sqflite/sqflite.dart';
import 'package:tcg_app_sp/models/userinfo.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DataBaseHelper{
  final databaseName = "users.db";
  String collectionTable = "CREATE TABLE collection (cardID TEXT, user TEXT, cardName TEXT, imgURL TEXT, cardType TEXT, PRIMARY KEY (cardID, user))";
  String userTable = "CREATE TABLE users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE NOT NULL, usrPassword TEXT NOT NULL)";

  Future<Database> initDB() async {
    const String customPath = "/Users/jonathanflores/code/Update SP/tcg-app-senior-proj-jonflo3/lib/SQLite"; 
    final path = join(customPath, databaseName);

    print("Database path: $path");

    return openDatabase(path, version: 2, onCreate: (db, version) async {
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

  //card related functions
  void addCardToCollection(String cardID, String user, String cardName, String imgURL, String cardType) async {
    final Database db = await initDB();

    String sql = "INSERT INTO collection (cardID, user, cardName, imgURL, cardType) VALUES ('$cardID', '$user', '$cardName', '$imgURL', '$cardType')";

    try {
      await db.transaction((txn) async {
        await txn.rawInsert(sql);
      });
    } catch (e) {
      print("Error inserting card into collection: $e");
    }
  }

  void deleteCardFromCollection(String cardID, String user) async {
    final Database db = await initDB();

    String whereClause = 'cardID = ? AND user = ?';
    List<dynamic> whereArgs = [cardID, user];

    try {
      await db.delete('collection', where: whereClause, whereArgs: whereArgs);
    } catch (e) {
      print("Error deleting card from collection: $e");
    }
  }

  Future<List<String>> getImageUrlsForUser(String user) async {
    final Database db = await initDB();

    List<Map<String, dynamic>> result = await db.query(
      'collection',
      columns: ['imgURL'],
      where: 'user = ?',
      whereArgs: [user],
    );

    List<String> imageUrls = result.map((row) => row['imgURL'] as String).toList();

    return imageUrls;
  }

  Future<List<String>> getCardIdsForUser(String user) async {
    final Database db = await initDB();

    List<Map<String, dynamic>> result = await db.query(
      'collection',
      columns: ['cardID'],
      where: 'user = ?',
      whereArgs: [user],
    );

    List<String> cardIds = result.map((row) => row['cardID'] as String).toList();

    return cardIds;
  }
}