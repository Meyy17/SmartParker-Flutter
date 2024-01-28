// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  static const tokenKey = "tokenUsers";
  static const roleKey = "role";

  setTokenSession(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(tokenKey, value);
  }

  setRoleAsUser(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(roleKey, value);
  }

  clearTokenSession() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(tokenKey);
  }

  Future<String> getTokenSession() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(tokenKey) ?? "";
  }

  Future<bool> getRoleAsUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(roleKey) ?? true;
  }
}
