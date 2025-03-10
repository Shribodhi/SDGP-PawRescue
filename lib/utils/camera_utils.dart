import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';

class CameraUtils {
  static Future<List<CameraDescription>> getCameras() async {
    try {
      return await availableCameras();
    } on CameraException catch (e) {
      debugPrint('Error getting cameras: ${e.description}');
      return [];
    }
  }

  static Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Check for Android 13 or higher
      if (await _isAndroid13OrHigher()) {
        var status = await Permission.photos.status;
        if (!status.isGranted) {
          status = await Permission.photos.request();
        }
        return status.isGranted;
      } else {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        return status.isGranted;
      }
    }
    return true; // For iOS and other platforms
  }

  static Future<bool> _isAndroid13OrHigher() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        return androidInfo.version.sdkInt >= 33; // Android 13 is API level 33
      }
      return false;
    } catch (e) {
      debugPrint('Error checking Android version: $e');
      return false;
    }
  }

  static Future<String?> takePicture(CameraController controller) async {
    if (!controller.value.isInitialized) {
      debugPrint('Camera not initialized');
      return null;
    }

    try {
      // Get directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${appDir.path}/Pictures/PawRescue';
      await Directory(dirPath).create(recursive: true);

      // Create filename
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(dirPath, fileName);

      final XFile photo = await controller.takePicture();
      await photo.saveTo(filePath);
      return filePath;
    } catch (e) {
      debugPrint('Error taking picture: $e');
      return null;
    }
  }

  static Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
