import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/source/local/user_data.dart';
import 'package:story_app/utils/constants.dart';

class LocalDatSource {
  void saveUserData(UserData userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.userData, json.encode(userData.toJson()));
  }

  Future<UserData> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userDataJson = prefs.getString(Constants.userData) ?? "";
    return UserData.fromJson(json.decode(userDataJson));
  }

  void deleteUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Constants.userData);
  }

  void saveStateLogin(bool isLogin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constants.isLogin, isLogin);
  }

  Future<bool> getStateLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.isLogin) ?? false;
  }

  void deleteStateLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Constants.isLogin);
  }

  void saveLocaleLanguage(String languange) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.language, languange);
  }

  Future<String> getLocaleLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Constants.language) ?? Constants.en;
  }
}
