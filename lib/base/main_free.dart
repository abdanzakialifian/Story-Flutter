import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/base/main_view_model.dart';
import 'package:story_app/base/story_app.dart';
import 'package:story_app/utils/flavor_type.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => MainViewModel(),
        child: const StoryApp(
          flavorType: FlavorType.free,
        ),
      ),
    );
