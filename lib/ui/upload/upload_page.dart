import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:story_app/ui/component/bottom_sheet_information.dart';
import 'package:story_app/ui/component/button_state.dart';
import 'package:story_app/ui/component/safe_on_tap.dart';
import 'package:story_app/ui/upload/upload_view_model.dart';
import 'package:story_app/utils/common.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/extensions.dart';
import 'package:story_app/utils/hexa_color.dart';
import 'package:story_app/utils/result_state.dart';

class UploadPage extends StatefulWidget {
  final File image;

  const UploadPage({Key? key, required this.image}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isEmptyTextEditing = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UploadViewModel>();

    return WillPopScope(
      onWillPop: () async {
        context.pop(Constants.resultData);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (_, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            SizedBox(
                              height: AppBar().preferredSize.height,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    SafeOnTap(
                                      onSafeTap: () =>
                                          context.pop(Constants.resultData),
                                      child: const Icon(Icons.arrow_back),
                                    ),
                                    Center(
                                      child: Text(
                                        AppLocalizations.of(context)
                                                ?.upload_story ??
                                            "",
                                        style: const TextStyle(
                                          fontFamily: Constants.manjariRegular,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.file(
                                          widget.image,
                                          height: 320,
                                          width: 220,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      controller: _textEditingController,
                                      onChanged: (value) {
                                        setState(() {
                                          _isEmptyTextEditing = value.isEmpty;
                                        });
                                      },
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      keyboardType: TextInputType.multiline,
                                      minLines: 6,
                                      maxLines: 8,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        decorationThickness: 0,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        isCollapsed: true,
                                        contentPadding:
                                            const EdgeInsets.all(20),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: HexColor(
                                                Constants.colorLightGrey),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: HexColor(
                                                Constants.colorDarkBlue),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        hintText: AppLocalizations.of(context)
                                            ?.hint_description,
                                        hintStyle: TextStyle(
                                          color: HexColor(
                                              Constants.colorLightGrey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    provider.locationAddress == ""
                                        ? SafeOnTap(
                                            onSafeTap: () => provider
                                                    .isWaitingOpenMap
                                                ? null
                                                : _checkPermissionMyLocation(
                                                    provider),
                                            child: Container(
                                              color: Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                    context)
                                                                ?.add_location ??
                                                            "",
                                                        style: const TextStyle(
                                                          fontFamily: Constants
                                                              .manjariBold,
                                                        ),
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 20,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      provider.locationAddress,
                                                      style: const TextStyle(
                                                        fontFamily: Constants
                                                            .manjariBold,
                                                      ),
                                                    ),
                                                  ),
                                                  SafeOnTap(
                                                    onSafeTap: () => provider
                                                        .setLocationAddress = "",
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Consumer<UploadViewModel>(
                                          builder: (_, value, child) {
                                            if (value.isButtonClicked) {
                                              return ButtonState(
                                                isLoading: true,
                                                onButtonPressed: () {},
                                              );
                                            } else {
                                              return ButtonState(
                                                textButton:
                                                    AppLocalizations.of(context)
                                                        ?.upload,
                                                onButtonPressed:
                                                    _isEmptyTextEditing
                                                        ? null
                                                        : () async {
                                                            provider.setIsButtonClicked =
                                                                true;
                                                            try {
                                                              var image =
                                                                  await _resizeImageIfLarge1MB(
                                                                      widget
                                                                          .image);
                                                              provider.postStory(
                                                                  image,
                                                                  _textEditingController
                                                                      .text);
                                                            } catch (error) {
                                                              log("Failed to compress image : $error");
                                                            }
                                                          },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    _stateUpload(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Center(
                child: provider.isWaitingOpenMap
                    ? SizedBox(
                        height: 110,
                        width: 150,
                        child: AlertDialog(
                          elevation: 2,
                          contentPadding: EdgeInsets.zero,
                          content: Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: HexColor(Constants.colorDarkBlue),
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stateUpload() {
    return Consumer<UploadViewModel>(
      builder: (context, value, child) {
        switch (value.resultState) {
          case ResultState.hasData:
            if (value.isButtonClicked) {
              value.successMessage.showSnackbar(context);
              Future.delayed(Duration.zero, () {
                context.pushReplacement(Constants.homePage);
              });
              resetButtonClicked(value);
            }
            return const SizedBox.shrink();
          case ResultState.hasError:
            if (value.isButtonClicked) {
              value.failedMessage.showSnackbar(context);
              resetButtonClicked(value);
            }
            return const SizedBox.shrink();
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  void resetButtonClicked(UploadViewModel value) {
    Future.delayed(Duration.zero, () {
      value.setIsButtonClicked = false;
    });
  }

  // resize image file
  Future<File> _resizeImageIfLarge1MB(File imageFile) async {
    final fileSize = await imageFile.length();

    if (fileSize <= 1024 * 1024) {
      return imageFile;
    }

    XFile? compressFileImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      imageFile.absolute.path,
      quality: 90,
    );

    int newFileSize = await compressFileImage?.length() ?? 0;

    // recursive if file size large than 1MB
    if (newFileSize > 1024 * 1024) {
      return _resizeImageIfLarge1MB(File(compressFileImage?.path ?? ""));
    } else {
      return File(compressFileImage?.path ?? "");
    }
  }

  void _checkPermissionMyLocation(UploadViewModel provider) async {
    final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
    final Position position;
    final LatLng latLng;
    LocationPermission locationPermission;
    bool isServiceEnabled = false;

    isServiceEnabled = await geolocatorPlatform.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      log("Location services is not available");
      return;
    }

    locationPermission = await geolocatorPlatform.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await geolocatorPlatform.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        log("Location permission is denied");
        return;
      }
      if (locationPermission == LocationPermission.deniedForever) {
        _showBottomSheetAccessDenied();
        return;
      }
    }

    try {
      provider.setIsWaitingOpenMap = true;

      position = await geolocatorPlatform.getCurrentPosition();

      provider.setIsWaitingOpenMap = false;

      latLng = LatLng(position.latitude, position.longitude);

      if (mounted) {
        context.push(Constants.locationPage, extra: latLng).then(
              (value) => provider.setLocationAddress = value.toString(),
            );
      }
    } catch (e) {
      provider.setIsWaitingOpenMap = false;
    }
  }

  dynamic _showBottomSheetAccessDenied() {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => BottomSheetInformation(
        iconName: "access_denied.png",
        iconHeight: 130,
        iconWidth: 130,
        title: AppLocalizations.of(context)?.title_access_denied ?? "",
        subTitle:
            AppLocalizations.of(context)?.sub_title_access_denied_location ??
                "",
        textButton: AppLocalizations.of(context)?.go_to_setting ?? "",
        onButtonPressed: () {
          // open app settings
          openAppSettings().then((_) {
            context.pop(context);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
