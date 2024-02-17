// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:camera/camera.dart';

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

class _CameraState extends State<Camera> {
  late CameraController controller;
  int selectedCameraIndex = 0;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onCapturePressed(context) async {
    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await controller.takePicture();
      print('Image captured and saved to ${file.path}');
    } catch (e) {
      print(e);
    }
  }

  void onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraController _newController = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.medium,
    );

    _newController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        controller = _newController;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Stack(
      children: <Widget>[
        CameraPreview(controller),
        Positioned(
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.camera, color: Colors.white),
                  onPressed: () => onCapturePressed(context),
                ),
                IconButton(
                  icon: Icon(Icons.switch_camera, color: Colors.white),
                  onPressed: onSwitchCamera,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
