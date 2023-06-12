import 'package:flutter/material.dart';

class CameraViewModel extends ChangeNotifier {
  bool _isCameraInitialize = false;
  bool _isRearCameraSelected = false;

  set setIsCameraInitialize(bool value) {
    _isCameraInitialize = value;
    notifyListeners();
  }

  set setIsRearCameraSelected(bool value) {
    _isRearCameraSelected = value;
    notifyListeners();
  }

  bool get isCameraInitialize => _isCameraInitialize;

  bool get isRearCameraSelected => _isRearCameraSelected;
}
