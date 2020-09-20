class DBUser {
  String id;
  String username;
  String password;
  bool isLogged;

  static const String table = 'users';
  static const String columnId = '_id';
  static const String columnUsername = 'username';
  static const String columnPassword = 'password';
  static const String columnIsLogged = 'is_logged';

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnUsername: username,
      columnPassword: password,
      columnIsLogged: isLogged ? 1 : 0,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  DBUser();

  DBUser.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    username = map[columnUsername];
    password = map[columnPassword];
    isLogged = map[columnIsLogged] == 1 ? true : false;
  }
}
