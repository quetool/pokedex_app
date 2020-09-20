import 'package:pokedex_app/models/db_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  Database database;

  Future<bool> init() async {
    var databasesPath = await getDatabasesPath();
    var dbPath = join(databasesPath, 'users.db');
    database = await open(dbPath);
    //
    // store dummy user to fake login
    var user = await getUser('0001');
    if (user == null) {
      await upsertUser(DBUser()
        ..id = '0001'
        ..username = 'alfredo'
        ..password =
            // ignore: lines_longer_than_80_chars
            'e1zo6Zc1uQa8U98NdBCA+UPfmQEXICBM8gy6CFeUwhHiojFHDRYiVnKeJ+hbmNfTfiRM7usitic85PTIg49WFw=='
        ..isLogged = false);
    }
    //
    return true;
  }

  Future<Database> open(String path) async {
    var db = await openDatabase(path, version: 1,
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
    var args = [user.id];
    var updated = await database.update(
      DBUser.table,
      user.toMap(),
      where: '${DBUser.columnId} = ?',
      whereArgs: args,
    );
    if (updated == 0) {
      await database.insert(DBUser.table, user.toMap());
    }
    return true;
  }

  Future<DBUser> getUser(String id) async {
    var args = [id];
    List<Map> maps = await database.query(
      DBUser.table,
      columns: [
        DBUser.columnId,
        DBUser.columnUsername,
        DBUser.columnPassword,
        DBUser.columnIsLogged,
      ],
      where: '${DBUser.columnId} = ?',
      whereArgs: args,
    );
    if (maps.isNotEmpty) {
      var user = DBUser.fromMap(maps.first as Map<String, dynamic>);
      return user;
    }
    return null;
  }

  Future<DBUser> loginUser(String username, String password) async {
    var args = [username, password];
    List<Map> maps = await database.query(
      DBUser.table,
      columns: [
        DBUser.columnId,
        DBUser.columnUsername,
        DBUser.columnPassword,
        DBUser.columnIsLogged,
      ],
      where: '${DBUser.columnUsername} = ? AND ${DBUser.columnPassword} = ?',
      whereArgs: args,
    );
    if (maps.isNotEmpty) {
      var user = DBUser.fromMap(maps.first as Map<String, dynamic>);
      return user;
    }
    return null;
  }
}
