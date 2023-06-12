import 'dart:io';

import 'package:story_app/data/source/local/user_data.dart';
import 'package:story_app/data/source/remote/response/login_response.dart';
import 'package:story_app/data/source/remote/response/base_response.dart';
import 'package:story_app/data/source/remote/response/stories_response.dart';

abstract class StoryRepository {
  Future<BaseResponse> postRegister(String name, String email, String password);
  Future<LoginResponse> postLogin(String email, String password);
  Future<UserData> getUserData();
  Future<bool> getStateLogin();
  Future<String> getLocaleLanguage();
  Future<StoriesResponse> getAllStories(int page, int size);
  Future<BaseResponse> postStory(File imageFile, String description);
  void saveUserData(UserData userData);
  void deleteUserData();
  void saveStateLogin(bool isLogin);
  void deleteStateLogin();
  void saveLocaleLanguage(String languange);
}
