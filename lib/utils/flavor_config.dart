import 'package:story_app/utils/flavor_type.dart';

class FlavorConfig {
  FlavorType? flavorType;
  String? titleApp;

  static FlavorConfig? _instance;

  FlavorConfig({
    this.flavorType = FlavorType.free,
    this.titleApp = "StoryApp",
  }) {
    _instance = this;
  }

  static FlavorConfig get instance => _instance ?? FlavorConfig();
}
