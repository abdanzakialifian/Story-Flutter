import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:story_app/base/main_view_model.dart';
import 'package:story_app/ui/component/bottom_sheet_information.dart';
import 'package:story_app/ui/component/button_state.dart';
import 'package:story_app/ui/component/safe_on_tap.dart';
import 'package:story_app/ui/profile/profile_view_model.dart';
import 'package:story_app/utils/common.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/extensions.dart';
import 'package:story_app/utils/function.dart';
import 'package:story_app/utils/hexa_color.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileViewModel>();
    final baseProvider = context.watch<MainViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SafeOnTap(
                    onSafeTap: () => baseProvider.setLanguage = Constants.en,
                    child: Text(
                      "EN",
                      style: TextStyle(
                        fontWeight: getFontWeight(baseProvider, Constants.en),
                        color: getColors(baseProvider, Constants.en),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text("|"),
                  const SizedBox(
                    width: 4,
                  ),
                  SafeOnTap(
                    onSafeTap: () => baseProvider.setLanguage = Constants.id,
                    child: Text(
                      "ID",
                      style: TextStyle(
                        fontWeight: getFontWeight(baseProvider, Constants.id),
                        color: getColors(baseProvider, Constants.id),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SafeOnTap(
                onSafeTap: () {
                  context.push(Constants.cameraStoryPreview).then((result) {
                    if (result == Constants.accessDenied) {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) => BottomSheetInformation(
                          iconName: "access_denied.png",
                          iconHeight: 130,
                          iconWidth: 130,
                          title: AppLocalizations.of(context)
                                  ?.title_access_denied ??
                              "",
                          subTitle: AppLocalizations.of(context)
                                  ?.sub_title_access_denied ??
                              "",
                          textButton:
                              AppLocalizations.of(context)?.go_to_setting ?? "",
                          onButtonPressed: () {
                            // open app settings
                            openAppSettings().then((_) {
                              context.pop(context);
                            });
                          },
                        ),
                      );
                    }
                  }).catchError((error) {
                    log("Failed return data from camera preview : $error");
                  });
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: Constants.avatar,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: AssetImage(
                            "avatar_profile.jpg".getImageAssets(),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    HexColor(Constants.colorDarkBlue),
                                radius: 16,
                                child: const Icon(
                                  Icons.add,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                provider.userData.userName ?? "",
                style: const TextStyle(
                  fontFamily: Constants.manjariBold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonState(
                textButton: AppLocalizations.of(context)?.logout,
                onButtonPressed: () {
                  provider.deleteStateLogin();
                  provider.deleteUserData();
                  context.go(Constants.loginPage);
                },
              ),
              Expanded(
                child: FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();
                    PackageInfo? packageInfo = snapshot.data;
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                          "${AppLocalizations.of(context)?.version} ${packageInfo?.version}"),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getVersionName() async {
    PackageInfo platform = await PackageInfo.fromPlatform();
    return platform.version;
  }
}
