// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom widgets

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:provider/provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/custom_code/actions/uploader.dart';

const goldColor = Color(0xFFFDD207);

class _ShutterButton extends StatelessWidget {
  final bool isTakingPicture;
  final void Function()? onPressed;
  const _ShutterButton({
    required this.isTakingPicture,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    const bringerColors = [
      Color(0xFFFFD400),
      Color(0xFFFFD204),
      Color(0xFF0CA8FE),
      Color(0xFF007EFC),
    ];
    return Container(
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(
            color: isTakingPicture ? Colors.white70 : Colors.white,
            width: 5,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            height: 56,
            width: 56,
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                colors: isTakingPicture
                    ? bringerColors
                        .map((color) => color.withOpacity(0.7))
                        .toList()
                    : bringerColors,
                stops: const [0, 0.2, 0.8, 1],
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class _CameraMode {
  static const portrait = 'Portrait';
  static const photo = 'Photo';
  static const nightSight = 'Night Sight';

  final String name;
  final bool isSelected;

  const _CameraMode({required this.name, required this.isSelected});
}

class _ModeSelector extends StatelessWidget {
  final void Function()? onTap;
  final _CameraMode mode;
  const _ModeSelector({required this.mode, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: mode.isSelected ? goldColor : Colors.transparent,
          child: Text(
            mode.name,
            style: TextStyle(
                color: mode.isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class Camera extends StatefulWidget {
  const Camera({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  CameraController? controller;
  late final List<CameraDescription> cameras;
  String? lastImagePath;
  int selectedCameraIndex = 0;
  bool hidSystemUI = false;
  FlashMode flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _fetchCameras();
    _fetchLastImage();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky).then((s) {
      setState(() {
        hidSystemUI = true;
      });
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller?.value.isInitialized ?? false) {
      if (state == AppLifecycleState.paused) {
        controller?.pausePreview();
      } else {
        controller?.resumePreview();
      }
    }
  }

  Future<void> _fetchLastImage() async {
    final lastImage = await SQLiteManager.instance
        .readImagesToUpload(ownerId: currentUserUid)
        .then((images) => images.firstOrNull);
    setState(() {
      lastImagePath = lastImage?.path;
    });
  }

  Future<void> _fetchCameras() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller?.setFlashMode(flashMode);
    await controller!.initialize();
    setState(() {});
  }

  Future<void> _onSwitchCamera() async {
    final nextCam = (selectedCameraIndex + 1) % cameras.length;
    controller?.setDescription(cameras[nextCam]);
    controller?.setFlashMode(flashMode);
    setState(() {
      selectedCameraIndex = nextCam;
    });
  }

  static Future _processImage(String path) async {
    Uint8List imageBytes = await File(path).readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);
    if (image != null) {
      img.Image sharpenedImage =
          img.adjustColor(image, amount: 1); // Increase sharpness
      await File(path).writeAsBytes(
          img.encodeJpg(sharpenedImage)); // Save the processed image.
    }
    return;
  }

  static Future<String> _onSaveImage(
    String filePath,
    RootIsolateToken token,
  ) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    debugPrint('Image captured and saved to $filePath');
    //await _processImage(filePath);

    final image = await File(filePath).readAsBytes();

    final fileName = p.basename(filePath);
    var newPath = '';
    if (defaultTargetPlatform == TargetPlatform.android) {
      final mediaStore = MediaStore();
      MediaStore.appFolder = 'Bringer';
      final isFileSaved = await mediaStore.saveFile(
        tempFilePath: filePath,
        dirType: DirType.photo,
        dirName: DirName.pictures,
      );
      if (isFileSaved) {
        newPath = '/sdcard/Pictures/Bringer/$fileName';
        await MediaScanner.loadMedia(path: newPath);
      }
    }

    if (newPath.isEmpty) {
      final path = '${await getExternalStorageDirectory()}/Pictures';
      await Directory(path).create(recursive: true);
      newPath = '$path/$fileName';
      await File(newPath).writeAsBytes(image);
    }

    debugPrint('Image captured and saved locally at $newPath');
    return newPath;
  }

  Future<void> _onCapturePressed() async {
    if (controller == null || controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }
    try {
      final uploader = Uploader();
      uploader.appState = context.read<FFAppState>();
      final file = await controller!.takePicture();
      final filePath = file.path;
      final rootIsolateToken = RootIsolateToken.instance!;
      final newPath = await compute(
        (message) async => await _onSaveImage(filePath, rootIsolateToken),
        null,
        debugLabel: 'SaveImageIsolate',
      );
      final unixTimestamp = DateTime.now().millisecondsSinceEpoch;
      await uploader.addToUploadQueue(newPath, unixTimestamp);
      return;
    } catch (e) {
      if (e is Error) {
        debugPrintStack(stackTrace: e.stackTrace);
      }
    }
  }

  bool _isLandscape(CameraValue val) =>
      val.deviceOrientation == DeviceOrientation.landscapeLeft ||
      val.deviceOrientation == DeviceOrientation.landscapeRight;

  @override
  Widget build(BuildContext context) {
    if (!hidSystemUI ||
        controller == null ||
        !controller!.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
        child: ValueListenableBuilder(
          valueListenable: controller!,
          builder: (context, val, child) {
            return Column(
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white70,
                        size: 28,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: val.description.lensDirection ==
                                  CameraLensDirection.front
                              ? null
                              : () {
                                  final newMode = flashMode == FlashMode.off
                                      ? FlashMode.always
                                      : FlashMode.off;
                                  setState(() {
                                    flashMode = newMode;
                                    controller?.setFlashMode(newMode);
                                  });
                                },
                          color: val.flashMode == FlashMode.off
                              ? Colors.white
                              : goldColor,
                          disabledColor: Colors.white60,
                          icon: Icon(
                            val.flashMode == FlashMode.off
                                ? Icons.flash_off_rounded
                                : Icons.flash_on_rounded,
                            size: 28,
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: const Icon(
                        //     Icons.timer,
                        //     color: Colors.white,
                        //     size: 28,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 100),
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: child,
                          ),
                          child: val.isTakingPicture
                              ? AspectRatio(
                                  aspectRatio:
                                      _isLandscape(val) ? 16 / 9 : 9 / 16,
                                  child: const SizedBox.expand(),
                                )
                              : Material(
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: CameraPreview(controller!),
                                ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 15, bottom: 45),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => context.goNamed('homeCopyCopy'),
                              child: Material(
                                color: Colors.transparent,
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                elevation: 1,
                                child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: Image(
                                    image: (lastImagePath == null
                                        ? const BlurHashImage(
                                            'eHNAr3_3xuxu%M~qWBt7IURjt79FIU%Mayt7ofWB%MWBM{%MRjD%ay')
                                        : FileImage(File(
                                            lastImagePath!))) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Semantics(
                                button: true,
                                label: 'Capture photo',
                                child: _ShutterButton(
                                  isTakingPicture: val.isTakingPicture,
                                  onPressed: Feedback.wrapForLongPress(
                                    _onCapturePressed,
                                    context,
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              shape: const CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              child: IconButton(
                                onPressed: Feedback.wrapForLongPress(
                                    _onSwitchCamera, context),
                                icon: const Icon(
                                  Icons.cameraswitch_outlined,
                                ),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                tooltip: 'Switch camera',
                                iconSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Compensating for the height lost by commenting the modes
                const SizedBox(height: 30),
                // const Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _ModeSelector(
                //       mode: _CameraMode(
                //         name: _CameraMode.portrait,
                //         isSelected: false,
                //       ),
                //     ),
                //     Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 24),
                //       child: _ModeSelector(
                //         mode: _CameraMode(
                //           name: _CameraMode.photo,
                //           isSelected: true,
                //         ),
                //       ),
                //     ),
                //     _ModeSelector(
                //       mode: _CameraMode(
                //         name: _CameraMode.nightSight,
                //         isSelected: false,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
