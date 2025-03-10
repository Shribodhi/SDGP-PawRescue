import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraTestPage extends StatefulWidget {
  const CameraTestPage({super.key});

  @override
  State<CameraTestPage> createState() => _CameraTestPageState();
}

class _CameraTestPageState extends State<CameraTestPage> {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      // Get available cameras
      cameras = await availableCameras();

      if (cameras.isEmpty) {
        setState(() {
          errorMessage = 'No cameras available';
        });
        return;
      }

      // Initialize the camera controller
      controller = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      // Initialize the controller
      await controller!.initialize();

      if (mounted) {
        setState(() {
          isReady = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error initializing camera: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera Test')),
        body: Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (!isReady || controller == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Camera Test')),
      body: Center(
        child: CameraPreview(controller!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camera is working!')),
          );
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
