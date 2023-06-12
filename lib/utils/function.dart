import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:story_app/base/main_view_model.dart';

Color getColors(MainViewModel baseProvider, String languageCode) =>
    (baseProvider.language == languageCode) ? Colors.black : Colors.grey;

FontWeight getFontWeight(MainViewModel baseProvider, String languageCode) =>
    (baseProvider.language == languageCode)
        ? FontWeight.w900
        : FontWeight.normal;

String dateFormat(String? date) {
  return DateFormat("dd MMM yyyy").format(
    DateTime.parse(date ?? "2022-03-30T18:56:17.33Z"),
  );
}
