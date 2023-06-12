import 'package:flutter/material.dart';
import 'package:story_app/data/repository/story_repository_impl.dart';
import 'package:story_app/data/source/remote/response/stories_response.dart';

class HomeViewModel extends ChangeNotifier {
  late final StoryRepositoryImpl _storyRepositoryImpl;

  HomeViewModel() : _storyRepositoryImpl = StoryRepositoryImpl();

  void saveStateLogin(bool value) {
    _storyRepositoryImpl.saveStateLogin(value);
  }

  Future<StoriesResponse> getAllStories(int page, int size) =>
      _storyRepositoryImpl.getAllStories(page, size);
}
