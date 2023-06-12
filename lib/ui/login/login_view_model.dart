import 'package:flutter/material.dart';
import 'package:story_app/data/repository/story_repository_impl.dart';
import 'package:story_app/data/source/local/user_data.dart';
import 'package:story_app/data/source/remote/response/login_response.dart';
import 'package:story_app/utils/result_state.dart';

class LoginViewModel extends ChangeNotifier {
  late final StoryRepositoryImpl _storyRepositoryImpl;

  ResultState _resultState = ResultState.initialState;
  LoginResultResponse _loginResultResponse = LoginResultResponse();
  String _failedMessage = "";

  String _inputEmail = "";
  String _inputPassword = "";
  bool _isButtonClicked = false;

  LoginViewModel() : _storyRepositoryImpl = StoryRepositoryImpl();

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

  LoginResultResponse get loginResultResponse => _loginResultResponse;

  String get failedMessage => _failedMessage;

  String get inputEmail => _inputEmail;

  String get inputPassword => _inputPassword;

  bool get isButtonClicked => _isButtonClicked;

  void postLogin(String email, String password) {
    _resultState = ResultState.loading;
    notifyListeners();
    _storyRepositoryImpl.postLogin(email, password).then((value) {
      if (value.error == false) {
        _resultState = ResultState.hasData;
        _loginResultResponse = value.loginResult ?? LoginResultResponse();
        // save to local if success login
        saveUserData(
          UserData(
            userId: value.loginResult?.userId,
            userName: value.loginResult?.name,
            userToken: value.loginResult?.token,
          ),
        );
      } else {
        _resultState = ResultState.hasError;
        _failedMessage = value.message.toString();
      }
    }).catchError((error) {
      _resultState = ResultState.hasError;
      _failedMessage = error.toString();
    }).whenComplete(notifyListeners);
  }

  void saveUserData(UserData userData) {
    _storyRepositoryImpl.saveUserData(userData);
  }
}
