import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:story_app/data/repository/story_repository_impl.dart';

class SplashScreenViewModel extends ChangeNotifier {
  late final StoryRepositoryImpl _storyRepositoryImpl;
  bool _isLogin = false;

  SplashScreenViewModel() : _storyRepositoryImpl = StoryRepositoryImpl() {
    getStateLogin();
  }

  bool get isLogin => _isLogin;

  void getStateLogin() {
    _storyRepositoryImpl.getStateLogin().then((value) {
      _isLogin = value;
    }).catchError((error) {
      log(error);
    }).whenComplete(notifyListeners);
  }
}
