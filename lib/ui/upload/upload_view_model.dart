import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:story_app/data/repository/story_repository_impl.dart';
import 'package:story_app/data/source/local/user_location.dart';
import 'package:story_app/utils/result_state.dart';

class UploadViewModel extends ChangeNotifier {
  late final StoryRepositoryImpl _storyRepositoryImpl;

  ResultState _resultState = ResultState.initialState;
  String _successMessage = "";
  String _failedMessage = "";
  bool _isButtonClicked = false;
  bool _isWaitingOpenMap = false;
  UserLocation _userLocation = UserLocation();

  UploadViewModel() : _storyRepositoryImpl = StoryRepositoryImpl();

  set setIsButtonClicked(bool value) {
    _isButtonClicked = value;
    notifyListeners();
  }

  set setIsWaitingOpenMap(bool value) {
    _isWaitingOpenMap = value;
    notifyListeners();
  }

  set setUserLocation(UserLocation value) {
    _userLocation = value;
    notifyListeners();
  }

  ResultState get resultState => _resultState;

  String get successMessage => _successMessage;

  String get failedMessage => _failedMessage;

  bool get isButtonClicked => _isButtonClicked;

  bool get isWaitingOpenMap => _isWaitingOpenMap;

  UserLocation get userLocation => _userLocation;

  void postStory(
    File imageFile,
    String description,
    double latitude,
    double longitude,
  ) {
    _resultState = ResultState.loading;
    notifyListeners();
    _storyRepositoryImpl
        .postStory(imageFile, description, latitude, longitude)
        .then((value) {
      if (value.error == false) {
        _resultState = ResultState.hasData;
        _successMessage = value.message.toString();
      } else {
        _resultState = ResultState.hasError;
        _failedMessage = value.message.toString();
      }
    }).catchError((error) {
      _resultState = ResultState.hasError;
      _failedMessage = error.toString();
    }).whenComplete(notifyListeners);
  }
}
