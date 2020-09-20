import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/digests/sha512.dart';
import 'package:pokedex_app/database/db_provider.dart';
import 'package:pokedex_app/helpers/strings.dart';
import 'package:pokedex_app/models/db_user.dart';

class Helpers {
  Future<bool> checkLogin(String userId) async {
    var dbProvider = DBProvider();
    await dbProvider.init();
    var user = await dbProvider.getUser(userId);
    return (user != null) ? user.isLogged : false;
  }

  void loginUser(String username, String password,
      Function(DBUser user, String error) completion) async {
    var dbProvider = DBProvider();
    await dbProvider.init();
    await dbProvider
        .loginUser(
      username,
      Helpers().hashPassword(password),
    )
        .then((DBUser dbUser) {
      if (dbUser != null) {
        dbUser.isLogged = true;
        dbProvider.upsertUser(dbUser).then((success) {
          if (success) {
            completion(dbUser, null);
          } else {
            completion(null, Strings.loginError);
          }
        });
      } else {
        completion(null, Strings.userNotFound);
      }
    });
  }

  void logOut(
      String userId, Function(bool success, String error) completion) async {
    var dbProvider = DBProvider();
    await dbProvider.init();
    await dbProvider.getUser(userId).then((dbUser) {
      dbUser.isLogged = false;
      dbProvider.upsertUser(dbUser).then((success) {
        completion(success, success ? null : Strings.loginOut);
      });
    });
  }

  String capitalize(String s) {
    if (s == '') return '';
    if (s.contains(' ')) {
      try {
        var newString = '';
        s.split(' ').forEach((part) {
          newString += (part[0] == '¿')
              ? part[0] +
                  part[1].toUpperCase() +
                  part.substring(2).toLowerCase()
              : part[0].toUpperCase() + part.substring(1).toLowerCase();
          newString += ' ';
        });
        newString = newString.trimRight();

        return newString;
      } catch (e) {
        return s;
      }
    }
    try {
      return (s[0] == '¿')
          ? s[0] + s[1].toUpperCase() + s.substring(2).toLowerCase()
          : s[0].toUpperCase() + s.substring(1).toLowerCase();
    } catch (e) {
      return s;
    }
  }

  String hashPassword(String password) {
    var bytes = utf8.encode('${password}pokedex') as Uint8List;
    var digest = SHA512Digest().process(bytes);
    return base64.encode(digest);
  }
}
