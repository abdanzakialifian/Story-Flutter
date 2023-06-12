import 'package:flutter/material.dart';

class FormInputFieldsViewModel extends ChangeNotifier {
  bool _isValidateEmail = true;
  bool _isValidatePassword = true;
  bool _isVisiblePassword = false;

  set setValidateEmail(bool isValidateEmail) {
    _isValidateEmail = isValidateEmail;
    notifyListeners();
  }

  set setValidatePassword(bool isValidatePassword) {
    _isValidatePassword = isValidatePassword;
    notifyListeners();
  }

  set setVisiblePassword(bool isVisiblePassword) {
    _isVisiblePassword = isVisiblePassword;
    notifyListeners();
  }

  bool get isValidateEmail => _isValidateEmail;

  bool get isValidatePassword => _isValidatePassword;

  bool get isVisiblePassword => _isVisiblePassword;
}
