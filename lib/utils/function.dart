import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

Future<Uint8List?> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ImageByteFormat.png))
      ?.buffer
      .asUint8List();
}
