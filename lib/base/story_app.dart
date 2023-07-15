import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/base/main_view_model.dart';
import 'package:story_app/config/routes/app_router.dart';
import 'package:story_app/utils/common.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/flavor_config.dart';
import 'package:story_app/utils/flavor_type.dart';

class StoryApp extends StatelessWidget {
  final FlavorType? flavorType;

  const StoryApp({super.key, this.flavorType});

  @override
  Widget build(BuildContext context) {
    final baseProvider = context.watch<MainViewModel>();
    // Title hardcoded because can't get localization
    if (flavorType == FlavorType.free) {
      FlavorConfig(
        flavorType: FlavorType.free,
        titleApp: "StoryApp",
      );
    } else {
      FlavorConfig(
        flavorType: FlavorType.pro,
        titleApp: "StoryApp Pro",
      );
    }
    return MaterialApp.router(
      locale: baseProvider.localLanguage,
      theme: ThemeData(fontFamily: Constants.manjariRegular),
      debugShowCheckedModeBanner: false,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
