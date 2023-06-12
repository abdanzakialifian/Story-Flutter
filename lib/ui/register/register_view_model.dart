import 'package:flutter/material.dart';
import 'package:story_app/data/repository/story_repository_impl.dart';
import 'package:story_app/utils/result_state.dart';

class RegisterViewModel extends ChangeNotifier {
  late final StoryRepositoryImpl _storyRepositoryImpl;

  ResultState _resultState = ResultState.initialState;
  String _successMessage = "";
  String _failedMessage = "";

  String _inputName = "";
  String _inputEmail = "";
  String _inputPassword = "";
  bool _isButtonClicked = false;

  RegisterViewModel() : _storyRepositoryImpl = StoryRepositoryImpl();

  set setInputName(String value) {
    _inputName = value;
    notifyListeners();
  }

  set setInputEmail(String value) {
    _inputEmail = value;
    notifyListeners();
  }

  set setInputPassword(String value) {
    _inputPassword = value;
    notifyListeners();
  }

  set setIsButtonClicked(bool value) {
    _isButtonClicked = value;
    notifyListeners();
  }

  ResultState get resultState => _resultState;

  String get successMessage => _successMessage;

  String get failedMessage => _failedMessage;

  String get inputName => _inputName;

  String get inputEmail => _inputEmail;

  String get inputPassword => _inputPassword;

  bool get isButtonClicked => _isButtonClicked;

  void postRegister(String name, String email, String password) {
    _resultState = ResultState.loading;
    notifyListeners();
    _storyRepositoryImpl.postRegister(name, email, password).then((value) {
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
