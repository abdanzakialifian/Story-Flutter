import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = context.read<UploadViewModel>();

    return WillPopScope(
      onWillPop: () async {
        context.pop(Constants.resultData);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                                    contentPadding: const EdgeInsets.all(20),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            HexColor(Constants.colorLightGrey),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            HexColor(Constants.colorDarkBlue),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: AppLocalizations.of(context)
                                        ?.hint_description,
                                    hintStyle: TextStyle(
                                      color: HexColor(Constants.colorLightGrey),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Consumer<UploadViewModel>(
                                      builder: (context, value, child) {
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
                                            onButtonPressed: () async {
                                              provider.setIsButtonClicked =
                                                  true;
                                              try {
                                                var image =
                                                    await _resizeImageIfLarge1MB(
                                                        widget.image);
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

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
