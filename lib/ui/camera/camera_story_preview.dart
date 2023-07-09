import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/ui/camera/camera_view_model.dart';
import 'package:story_app/ui/component/safe_on_tap.dart';
import 'package:story_app/utils/constants.dart';

class CameraStoryPreview extends StatefulWidget {
  const CameraStoryPreview({Key? key}) : super(key: key);

  @override
  State<CameraStoryPreview> createState() => _CameraStoryPreviewState();
}

class _CameraStoryPreviewState extends State<CameraStoryPreview>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isLifeCyclePaused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    availableCameras()
        .then((cameras) => _initializeCameraController(cameras[0]))
        .catchError((error) {
      log("Failed get cameras : $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CameraViewModel>();

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: provider.isCameraInitialize
                ? Transform.scale(
                    scale: 1 /
                        ((_controller?.value.aspectRatio ?? 0) *
                            MediaQuery.of(context).size.aspectRatio),
                    child: CameraPreview(_controller!),
                  )
                : Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20,
              left: 20,
              right: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SafeOnTap(
                  onSafeTap: () {
                    _onGallerySelected(provider);
                  },
                  child: const Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                SafeOnTap(
                  onSafeTap: () {
                    _onTakePicture(provider);
                  },
                  child: const Icon(
                    Icons.camera,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                SafeOnTap(
                  onSafeTap: () {
                    _onSwitchCamera(provider);
                  },
                  child: const Icon(
                    Icons.cameraswitch,
                    size: 50,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onGallerySelected(CameraViewModel provider) {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      if (value == null) return;
      final imageFile = File(value.path);

      // delay 500 milliseconds to get initialize camera
      Future.delayed(const Duration(milliseconds: 500), () {
        // dispose camera if navigate to another pages
        final CameraController? cameraController = _controller;
        if (cameraController == null || !cameraController.value.isInitialized) {
          return;
        }
        provider.setIsCameraInitialize = false;
        cameraController.dispose();

        context.push(Constants.uploadPage, extra: imageFile).then((value) {
          // get return data from next page
          if (value == Constants.resultData) {
            _initializeCameraController(cameraController.description);
          }
        });
      });
    }).catchError((error) {
      log("Failed to pick image: $error");
    });
  }

  void _onTakePicture(CameraViewModel provider) {
    takePicture().then((value) {
      if (value == null) return;
      final imageFile = File(value.path);

      // dispose camera if navigate to another pages
      final CameraController? cameraController = _controller;
      if (cameraController == null || !cameraController.value.isInitialized) {
        return;
      }
      provider.setIsCameraInitialize = false;
      cameraController.dispose();

      context.push(Constants.uploadPage, extra: imageFile).then((value) {
        // get return data from next page
        if (value == Constants.resultData) {
          _initializeCameraController(cameraController.description);
        }
      });
    }).catchError((error) {
      log("Failed to take picture: $error");
    });
  }

  void _onSwitchCamera(CameraViewModel provider) {
    provider.setIsRearCameraSelected = !provider.isRearCameraSelected;
    provider.setIsCameraInitialize = false;

    availableCameras()
        .then((cameras) => _initializeCameraController(cameras[0]))
        .catchError((error) {
      log("Failed get cameras : $error");
    });
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = _controller;
    if (cameraController?.value.isTakingPicture == true) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile? file = await cameraController?.takePicture();
      return file;
    } on CameraException catch (error) {
      log("Error occured while taking picture: $error");
      return null;
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController? previousCameraController = _controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        _controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await _controller?.initialize();
    } on CameraException catch (_) {
      if (!mounted) return;
      // set delay to avoid crashes
      Future.delayed(const Duration(milliseconds: 500), () {
        context.pop(Constants.accessDenied);
      });
    }

    // Update the Boolean
    if (mounted) {
      context.read<CameraViewModel>().setIsCameraInitialize =
          _controller?.value.isInitialized ?? false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.paused) {
      // Free up memory when camera not active
      setState(() {
        _isLifeCyclePaused = true;
      });
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_isLifeCyclePaused) {
        setState(() {
          _isLifeCyclePaused = false;
        });
        context.read<CameraViewModel>().setIsCameraInitialize = false;
        // Reinitialize the camera with same properties
        _initializeCameraController(cameraController.description);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }
}
