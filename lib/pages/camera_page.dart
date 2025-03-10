import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../utils/camera_utils.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraPermissionGranted = false;
  bool _isStoragePermissionGranted = false;
  File? _capturedImage;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    _isCameraPermissionGranted = await CameraUtils.requestCameraPermission();
    _isStoragePermissionGranted = await CameraUtils.requestStoragePermission();

    if (!_isCameraPermissionGranted) {
      _showPermissionDeniedDialog('Camera');
      return;
    }

    if (!_isStoragePermissionGranted) {
      _showPermissionDeniedDialog('Storage');
      return;
    }

    _cameras = await CameraUtils.getCameras();
    if (_cameras.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No cameras found')),
        );
      }
      return;
    }

    _initCameraController();
  }

  Future<void> _initCameraController() async {
    if (_cameras.isEmpty || _controller != null) return;

    try {
      _controller = CameraController(
        _cameras[_selectedCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) setState(() {});
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: ${e.description}');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final String? filePath = await CameraUtils.takePicture(_controller!);

      if (filePath != null) {
        setState(() {
          _capturedImage = File(filePath);
        });
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  void _toggleCamera() {
    if (_cameras.length <= 1) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    _controller?.dispose();
    _controller = null;
    _initCameraController();
  }

  void _pickFromGallery() async {
    final File? image = await CameraUtils.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _capturedImage = image;
      });
    }
  }

  void _showPermissionDeniedDialog(String permissionType) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('$permissionType Permission Required'),
          content: Text(
              'The app needs $permissionType permission to function properly.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_capturedImage != null) {
      return _buildImagePreviewScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: _buildCameraPreview(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraPermissionGranted || !_isStoragePermissionGranted) {
      return const Center(
        child: Text('Camera or Storage permission not granted'),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: CameraPreview(_controller!),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _pickFromGallery,
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, size: 36),
            onPressed: _takePicture,
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_android),
            onPressed: _cameras.length > 1 ? _toggleCamera : null,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreviewScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, _capturedImage!.path);
            },
          ),
        ],
      ),
      body: Center(
        child: Image.file(_capturedImage!),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retake'),
              onPressed: () {
                setState(() {
                  _capturedImage = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
