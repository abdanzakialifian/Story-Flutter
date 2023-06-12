import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:story_app/data/repository/story_repository_impl.dart';
import 'package:story_app/data/source/local/user_data.dart';

class ProfileViewModel extends ChangeNotifier {
  late final StoryRepositoryImpl _storyRepositoryImpl;
  UserData _userData = UserData();

  ProfileViewModel() : _storyRepositoryImpl = StoryRepositoryImpl() {
    getUserData();
  }

  UserData get userData => _userData;

  void getUserData() {
    _storyRepositoryImpl.getUserData().then((value) {
      _userData = value;
    }).catchError((error) {
      log(error);
    }).whenComplete(notifyListeners);
  }

  void deleteStateLogin() {
    _storyRepositoryImpl.deleteStateLogin();
  }

  void deleteUserData() {
    _storyRepositoryImpl.deleteUserData();
  }
}
