import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/base/main_view_model.dart';
import 'package:story_app/config/routes/app_router.dart';
import 'package:story_app/utils/common.dart';
import 'package:story_app/utils/constants.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => MainViewModel(),
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseProvider = context.watch<MainViewModel>();
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
