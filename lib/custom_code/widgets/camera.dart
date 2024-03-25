// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:provider/provider.dart';
import '/custom_code/actions/uploader.dart';

class _ShutterButton extends StatelessWidget {
  final bool isTakingPicture;
  final void Function()? onPressed;
  const _ShutterButton({
    required this.isTakingPicture,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(color: Colors.white, width: 2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            margin: const EdgeInsets.all(5),
            height: 60,
            width: 60,
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: isTakingPicture ? Colors.white70 : Colors.white,
            ),
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
  int selectedCameraIndex = 0;
  bool hidSystemUI = false;

  @override
  void initState() {
    super.initState();
    _fetchCameras();
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

  Future<void> _fetchCameras() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller!.initialize();
    setState(() {});
  }

  Future<void> _onSwitchCamera() async {
    final nextCam = (selectedCameraIndex + 1) % cameras.length;
    controller?.setDescription(cameras[nextCam]);
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
    await _processImage(filePath);

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
      final file = await controller!.takePicture();
      final filePath = file.path;
      final rootIsolateToken = RootIsolateToken.instance!;
      final newPath = await compute(
        (message) async => await _onSaveImage(filePath, rootIsolateToken),
        null,
        debugLabel: 'SaveImageIsolate',
      );
      final unixTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final uploader = Uploader();
      uploader.appState = context.read<FFAppState>();
      await uploader.addToUploadQueue(newPath, unixTimestamp);
      return;
    } catch (e) {
      if (e is Error) {
        debugPrintStack(stackTrace: e.stackTrace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!hidSystemUI) return Container();
    return SafeArea(
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: controller == null || !controller!.value.isInitialized
                  ? const Icon(Icons.camera_rounded)
                  : CameraPreview(controller!)),
          Container(
            padding: const EdgeInsets.only(top: 15, bottom: 45),
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: IconButton(
                    onPressed: () => context.goNamed('homeCopy'),
                    icon: const Icon(Icons.photo_library_rounded),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    tooltip: 'Gallery',
                    iconSize: 24,
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Capture photo',
                  child: controller != null
                      ? ValueListenableBuilder(
                          valueListenable: controller!,
                          builder: (context, val, child) => _ShutterButton(
                            isTakingPicture: val.isTakingPicture,
                            onPressed: Feedback.wrapForLongPress(
                              _onCapturePressed,
                              context,
                            ),
                          ),
                        )
                      : const _ShutterButton(isTakingPicture: true),
                ),
                Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: IconButton(
                    onPressed:
                        Feedback.wrapForLongPress(_onSwitchCamera, context),
                    icon: const Icon(
                      Icons.cameraswitch_outlined,
                    ),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    tooltip: 'Switch camera',
                    iconSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
