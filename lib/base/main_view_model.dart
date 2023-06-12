import 'dart:math';
import 'package:flutter/material.dart';
import 'package:story_app/data/repository/story_repository_impl.dart';
import 'package:story_app/utils/constants.dart';

class MainViewModel extends ChangeNotifier {
  late final StoryRepositoryImpl _storyRepositoryImpl;
  Locale _localeLanguage = const Locale(Constants.en);
  String _language = Constants.en;

  MainViewModel() : _storyRepositoryImpl = StoryRepositoryImpl() {
    getLocaleLanguage();
  }

  set setLanguage(String value) {
    _localeLanguage = Locale(value);
    _language = value;
    _storyRepositoryImpl.saveLocaleLanguage(value);
    notifyListeners();
  }

  Locale get localLanguage => _localeLanguage;

  String get language => _language;

  void getLocaleLanguage() {
    _storyRepositoryImpl.getLocaleLanguage().then((value) {
      _language = value;
      _localeLanguage = Locale(value);
    }).catchError((error) {
      log(error);
    }).whenComplete(notifyListeners);
  }
}
