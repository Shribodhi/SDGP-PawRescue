import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'stray_animal_form.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> cameras = [];
  bool _isReady = false;
  bool _takingPicture = false;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize the camera
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _requestCameraPermission() async {
    print("Requesting camera permission...");
    final status = await Permission.camera.request();
    print("Camera permission status: $status");

    if (status.isGranted) {
      _initializeCamera();
    } else {
      if (!mounted) return;

      setState(() {
        _permissionDenied = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to use this feature'),
          ),
        );
      }
    }
  }

  Future<void> _initializeCamera() async {
    print("Initializing camera...");
    try {
      cameras = await availableCameras();
      print("Available cameras: ${cameras.length}");

      if (cameras.isEmpty) {
        print("No cameras found");
        if (mounted) {
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            const SnackBar(content: Text('No cameras found on this device')),
          );
        }
        return;
      }

      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      print("Initializing controller...");
      await _controller!.initialize();
      print("Controller initialized");

      if (!mounted) return;

      setState(() {
        _isReady = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
      if (mounted) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(
              content: Text('Failed to initialize camera: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _takingPicture) {
      return;
    }

    // Add mounted check before setState
    if (!mounted) return;

    setState(() {
      _takingPicture = true;
    });

    try {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = join(directory.path, fileName);

      XFile picture = await _controller!.takePicture();
      await picture.saveTo(path);

      if (!mounted) return;

      Navigator.push(
        context as BuildContext,
        MaterialPageRoute(
          builder: (BuildContext context) => StrayAnimalForm(imagePath: path),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Failed to take picture: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _takingPicture = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Camera Access Denied'),
          backgroundColor: const Color(0xFF023047),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.no_photography,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Camera permission is required',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _requestCameraPermission(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF219EBC),
                ),
                child: const Text('Allow Camera Access',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isReady || _controller == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a Photo of the Stray Animal'),
        backgroundColor: const Color(0xFF023047),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Stack(
                children: [
                  CameraPreview(_controller!),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: _takingPicture ? null : _takePicture,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Colors.white,
                          ),
                          child: _takingPicture
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.camera_alt,
                                  size: 40, color: Color(0xFF023047)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            color: Colors.white,
            child: const Text(
              'Take a clear photo of the stray animal. This will help the rescue team identify and locate it.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
