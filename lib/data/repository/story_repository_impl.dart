import 'dart:io';

import 'package:story_app/data/repository/story_repository.dart';
import 'package:story_app/data/source/local/local_data_source.dart';
import 'package:story_app/data/source/local/user_data.dart';
import 'package:story_app/data/source/remote/remote_data_source.dart';
import 'package:story_app/data/source/remote/response/login_response.dart';
import 'package:story_app/data/source/remote/response/base_response.dart';
import 'package:story_app/data/source/remote/response/stories_response.dart';

class StoryRepositoryImpl implements StoryRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDatSource _localDatSource = LocalDatSource();

  @override
  Future<BaseResponse> postRegister(
          String name, String email, String password) =>
      _remoteDataSource.postRegister(name, email, password);

  @override
  Future<LoginResponse> postLogin(String email, String password) =>
      _remoteDataSource.postLogin(email, password);

  @override
  Future<UserData> getUserData() => _localDatSource.getUserData();

  @override
  void saveUserData(UserData userData) {
    _localDatSource.saveUserData(userData);
  }

  @override
  void deleteUserData() {
    _localDatSource.deleteUserData();
  }

  @override
  Future<bool> getStateLogin() => _localDatSource.getStateLogin();

  @override
  void saveStateLogin(bool isLogin) {
    _localDatSource.saveStateLogin(isLogin);
  }

  @override
  void deleteStateLogin() {
    _localDatSource.deleteStateLogin();
  }

  @override
  Future<String> getLocaleLanguage() => _localDatSource.getLocaleLanguage();

  @override
  void saveLocaleLanguage(String languange) {
    _localDatSource.saveLocaleLanguage(languange);
  }

  @override
  Future<StoriesResponse> getAllStories(int page, int size) =>
      _remoteDataSource.getAllStories(page, size);

  @override
  Future<BaseResponse> postStory(File imageFile, String description) =>
      _remoteDataSource.postStory(imageFile, description);
}
