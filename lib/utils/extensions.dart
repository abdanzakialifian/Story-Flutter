import 'package:flutter/material.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/hexa_color.dart';

extension StringExtension on String {
  Future showSnackbar(BuildContext context) => Future.delayed(
        Duration.zero,
        () {
          SnackBar snackBar = SnackBar(
            backgroundColor: HexColor(Constants.colorDarkBlue),
            duration: const Duration(seconds: 1),
            content: Text(this),
            behavior: SnackBarBehavior.floating,
            elevation: 6,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );

  String getImageAssets() => "assets/images/$this";

  bool validateEmail() => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(this);

  bool validatePassword() => length < 8 ? false : true;

  String capitalizeByWord() {
    if (trim().isEmpty) {
      return '';
    }
    final List<String> newList = [];
    split(' ').forEach(
      (element) {
        if (element.isNotEmpty) {
          newList.add(element);
        }
      },
    );
    return newList
        .map((element) =>
            "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
        .join(" ");
  }
}
