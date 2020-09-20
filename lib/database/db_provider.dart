import 'package:pokedex_app/models/db_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  Database database;

  Future<bool> init() async {
    var databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'users.db');
    this.database = await open(dbPath);
    //
    // store dummy user to fake login
    DBUser user = await getUser("0001");
    if (user == null) {
      await upsertUser(DBUser()
        ..id = "0001"
        ..username = "alfredo"
        ..password =
            "e1zo6Zc1uQa8U98NdBCA+UPfmQEXICBM8gy6CFeUwhHiojFHDRYiVnKeJ+hbmNfTfiRM7usitic85PTIg49WFw=="
        ..isLogged = false);
    }
    //
    return true;
  }

  Future<Database> open(String path) async {
    Database db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table ${DBUser.table} ( 
          ${DBUser.columnId} text primary key, 
          ${DBUser.columnUsername} text not null,
          ${DBUser.columnPassword} text not null,
          ${DBUser.columnIsLogged} bool not null)
      ''');
    });
    return db;
  }

  Future<bool> upsertUser(DBUser user) async {
    var updated = await this.database.update(
      DBUser.table,
      user.toMap(),
      where: '${DBUser.columnId} = ?',
      whereArgs: [user.id],
    );
    if (updated == 0) {
      await this.database.insert(DBUser.table, user.toMap());
    }
    return true;
  }

  Future<DBUser> getUser(String id) async {
    List<Map> maps = await this.database.query(DBUser.table,
        columns: [
          DBUser.columnId,
          DBUser.columnUsername,
          DBUser.columnPassword,
          DBUser.columnIsLogged,
        ],
        where: '${DBUser.columnId} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      var user = DBUser.fromMap(maps.first);
      return user;
    }
    return null;
  }

  Future<DBUser> loginUser(String username, String password) async {
    List<Map> maps = await this.database.query(DBUser.table,
        columns: [
          DBUser.columnId,
          DBUser.columnUsername,
          DBUser.columnPassword,
          DBUser.columnIsLogged,
        ],
        where: '${DBUser.columnUsername} = ? AND ${DBUser.columnPassword} = ?',
        whereArgs: [username, password]);
    if (maps.length > 0) {
      var user = DBUser.fromMap(maps.first);
      return user;
    }
    return null;
  }
}
