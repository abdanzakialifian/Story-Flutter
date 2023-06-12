import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/ui/camera/camera_story_preview.dart';
import 'package:story_app/config/routes/custom_slide_transition.dart';
import 'package:story_app/ui/camera/camera_view_model.dart';
import 'package:story_app/ui/component/form_input_fields_view_model.dart';
import 'package:story_app/ui/home/home_page.dart';
import 'package:story_app/ui/home/home_view_model.dart';
import 'package:story_app/ui/login/login_page.dart';
import 'package:story_app/ui/login/login_view_model.dart';
import 'package:story_app/ui/register/register_page.dart';
import 'package:story_app/ui/register/register_view_model.dart';
import 'package:story_app/ui/profile/profile_page.dart';
import 'package:story_app/ui/profile/profile_view_model.dart';
import 'package:story_app/ui/splashscreen/splash_screen_page.dart';
import 'package:story_app/ui/splashscreen/splash_screen_view_model.dart';
import 'package:story_app/ui/upload/upload_page.dart';
import 'package:story_app/ui/upload/upload_view_model.dart';
import 'package:story_app/utils/constants.dart';

class AppRouter {
  static Widget splashScreenPageRouteBuilder(
          BuildContext context, GoRouterState state) =>
      ChangeNotifierProvider(
        create: (context) => SplashScreenViewModel(),
        child: const SplashScreenPage(),
      );

  static Page loginPageRouteBuilder(
          BuildContext context, GoRouterState state) =>
      CustomSlideTransition(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => FormInputFieldsViewModel(),
            ),
            ChangeNotifierProvider(
              create: (context) => LoginViewModel(),
            ),
          ],
          child: const LoginPage(),
        ),
      );

  static Widget registerPageRouteBuilder(
          BuildContext context, GoRouterState state) =>
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => FormInputFieldsViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => RegisterViewModel(),
          ),
        ],
        child: const RegisterPage(),
      );

  static Page homePageRouteBuilder(BuildContext context, GoRouterState state) =>
      CustomSlideTransition(
        child: ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
          child: const HomePage(),
        ),
      );

  static Page profilePageRouteBuilder(
          BuildContext context, GoRouterState state) =>
      CustomSlideTransition(
        child: ChangeNotifierProvider(
          create: (context) => ProfileViewModel(),
          child: const ProfilePage(),
        ),
      );

  static Widget cameraStoryPreviewRouteBuilder(
          BuildContext context, GoRouterState state) =>
      ChangeNotifierProvider(
        create: (context) => CameraViewModel(),
        child: const CameraStoryPreview(),
      );

  static Widget uploadPageRouteBuilder(
          BuildContext context, GoRouterState state) =>
      ChangeNotifierProvider(
        create: (context) => UploadViewModel(),
        child: UploadPage(
          image: state.extra as File,
        ),
      );

  // use this in [MaterialApp.router]
  static final GoRouter _router = GoRouter(
    initialLocation: Constants.splashScreenPage,
    routes: <GoRoute>[
      GoRoute(
        path: Constants.splashScreenPage,
        builder: splashScreenPageRouteBuilder,
      ),
      GoRoute(
        path: Constants.loginPage,
        pageBuilder: loginPageRouteBuilder,
      ),
      GoRoute(
        path: Constants.registerPage,
        builder: registerPageRouteBuilder,
      ),
      GoRoute(
        path: Constants.homePage,
        pageBuilder: homePageRouteBuilder,
      ),
      GoRoute(
        path: Constants.profilePage,
        pageBuilder: profilePageRouteBuilder,
      ),
      GoRoute(
        path: Constants.cameraStoryPreview,
        builder: cameraStoryPreviewRouteBuilder,
      ),
      GoRoute(
        path: Constants.uploadPage,
        builder: uploadPageRouteBuilder,
      ),
    ],
  );

  // use this in [MaterialApp.router]
  static GoRouter get router => _router;
}
