import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/ui/splashscreen/splash_screen_view_model.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/extensions.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<SplashScreenViewModel>();
    Timer(const Duration(seconds: 3), () {
      if (provider.isLogin) {
        context.go(Constants.homePage);
      } else {
        context.go(Constants.loginPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Hero(
        tag: Constants.storyLogo,
        child: Image.asset(
          "story_logo.png".getImageAssets(),
          width: 150,
          height: 150,
        ),
      )),
    );
  }
}
