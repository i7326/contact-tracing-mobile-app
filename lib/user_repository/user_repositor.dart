import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:coloc/config/api_config.dart';
import 'package:coloc/model/user.dart';
import 'package:bip39/bip39.dart' as bip39;

class UserRepository {
  String token;
  Map user;

  Future<String> generatePhrase() async {
    try {
        String randomMnemonic = bip39.generateMnemonic();
        return randomMnemonic;
    } catch (err) {
      throw new Exception(err);
    }
  }

  Future<String> authenticate({
    @required String phrase,
  }) async {
    try {
      final dio = Dio();
      Response res = await dio.post("${APIConfig.SERVER_IP}/auth/login",
          data: jsonEncode({"phrase": phrase}),
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              }));
      if (res.statusCode == 302) {
        res = await dio.post("${APIConfig.SERVER_IP}/auth/register",
            data: jsonEncode({"phrase": phrase}));
      }
      if (res.statusCode == 200) return res.data;
    } catch (err) {
      throw new Exception(err);
    }
    throw new Exception("Login failed");
  }

  Future<void> saveFCMToken(String fcmToken, String authToken) async {
    try {
      final dio = Dio();
      await dio.post("${APIConfig.SERVER_IP}/auth/notification-token",
          data: jsonEncode({"notificationToken": fcmToken}),
          options: Options(headers: {"authorization": "Bearer $authToken"}));
    } catch (err) {
      throw new Exception(err);
    }
    return;
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    final storage = new Storage.FlutterSecureStorage();
    try {
      await storage.write(key: 'token', value: token);
      this.token = token;
    } catch (err) {
      throw new Exception(err);
    }
    return;
  }

  Future<void> persistClientAddress(String address) async {
    final storage = new Storage.FlutterSecureStorage();
    try {
      await storage.write(key: 'clientAddress', value: address);
      APIConfig.SERVER_IP = address;
    } catch (err) {
      throw new Exception(err);
    }
    return;
  }

  Future<void> clearClientAddress() async {
    final storage = new Storage.FlutterSecureStorage();
    try {
      await storage.delete(key: 'clientAddress');
      APIConfig.SERVER_IP = null;
    } catch (err) {
      throw new Exception(err);
    }
    return;
  }

  Future<bool> hasToken() async {
    return await getToken() != null;
  }

  Future<String> getToken() async {
    final storage = new Storage.FlutterSecureStorage();
    try {
      token = await storage.read(key: 'token');
    } catch (err) {
      throw new Exception(err);
    }
    return token;
  }

  Future getUser() async {
    if (token != null) {
      return User.fromJson(await json.decode(
          ascii.decode(base64.decode(base64.normalize(token.split(".")[1])))));
      //.map((contact) => Contact.fromJson(contact));
    } else {
      return User.fromJson(await json.decode(ascii.decode(
          base64.decode(base64.normalize((await getToken()).split(".")[1])))));
    }
  }
}
