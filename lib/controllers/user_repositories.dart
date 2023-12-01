import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:jendela_dbp/controllers/global_var.dart';
import 'package:jendela_dbp/model/userModel.dart';
class UserRepository {
  User? _user;
  Box? _box;
  FlutterSecureStorage? _secureStorage;
  dynamic _encryptionKey;

  Future<bool> init() async {
    try {
      Hive.init(await getlocalPath());
      Hive.registerAdapter(UserAdapter());
      Hive.ignoreTypeId<User>(32);
      await openBox();
    } catch (error) {
      return false;
    }
    return true;
  }

  Future<bool> openBox() async {
    try {
      // store token
      _secureStorage = const FlutterSecureStorage();
      // get secure key
      var containsEncryptionKey = await _secureStorage!.containsKey(key: 'key');
      if (!containsEncryptionKey) {
        // generate key
        var key = Hive.generateSecureKey();
        // store key
        await _secureStorage!.write(key: 'key', value: base64UrlEncode(key));
      }
      // read key
      _encryptionKey =
          base64Url.decode((await _secureStorage!.read(key: 'key')) ?? '');
      // print('Encryption key: $_encryptionKey');
      // open auth box
      _box = await Hive.openBox('auth',
          encryptionCipher: HiveAesCipher(_encryptionKey));
    } catch (error) {
      rethrow;
    }
    return true;
  }

  void dispose() {
    if (_box != null) {
      _box!.close();
    }
  }

  Future<User?> authenticate({
    required String username,
    required String password,
  }) async {
    try {
      var response = await http.post(
          Uri.https(GlobalVar.baseURLDomain, 'wp-json/jwt-auth/v1/token'),
          headers: {},
          body: {'username': username, 'password': password});
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if (response.statusCode != 200) {
        return null;
      }
      var body = jsonDecode(response.body);
      _user = User(
          name: body['user_display_name'],
          email: body['user_email'],
          jwtToken: body['token']);
      // get me
      _box!.put('user', _user);
    } catch (e) {
      // print(e);
      rethrow;
    }
    return _user;
  }

  // Future<void> persistToken(String token) async {
  //   /// write to keystore/keychain
  //   await Future.delayed(Duration(seconds: 1));
  //   return;
  // }

  Future<bool> hasToken() async {
    String? token;
    _user ??= _box!.get('user');
    if (_user != null) {
      token = _user!.jwtToken;
    }
    // print("token: " + token.toString());
    return token == null ? false : true;
  }

  Future<String?> getToken() async {
    String? token;
    _user ??= _box!.get('user');
    if (_user != null) {
      token = _user!.jwtToken;
    }
    // print("token: " + token.toString());
    return token;
  }

  Future<User?> getUser() async {
    _user ??= _box!.get('user');
    return _user;
  }

  Future<bool> validateToken() async {
    try {
      if (_user == null) {
        _user = _box!.get('user');
        if (_user == null) {
          throw 'User Null';
        }
      }
      var response = await http.post(
          Uri.https(
              GlobalVar.baseURLDomain, 'wp-json/jwt-auth/v1/token/validate'),
          headers: {'Authorization': 'Bearer ${_user!.jwtToken ?? ''}'},
          body: {});
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if (response.statusCode != 200) {
        return false;
      }
      var body = jsonDecode(response.body);
      _user = User(
          name: body['user_display_name'],
          email: body['user_email'],
          jwtToken: body['token']);
      _box!.put('user', _user);
    } catch (e) {
      // print(e);
      return false;
    }
    return true;
  }

  Future<void> deleteToken() async {
    _box!.clear();
  }

  Future<String> getlocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    // print('localPath : ${directory.path}');
    return directory.path;
  }

  Future<bool> updateUser(User user) async {
    try {
      _user = user;
      if (_box!.isOpen) {
        await _box!.put('user', user);
      } else {
        throw 'Box Not Open';
      }
    } catch (e) {
      rethrow;
    }
    return true;
  }
}
