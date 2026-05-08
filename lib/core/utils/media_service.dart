/* 
 * Top Comment: Advanced Media Service implementing secure file relocation, 
 * JPEG optimization, and privacy-first gallery exclusion.
 */
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'logger.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  /// Captures an image and moves it to the app's private internal storage.
  Future<String?> captureSecureImage() async {
    try {
      // 1. Hardware Input & Compression (Textbook Ref: Ch 5.3.1)
      final XFile? rawImage = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1280, // HD Standard
        imageQuality:
            70, // Balanced compression for low-bandwidth Tigray regions
      );

      if (rawImage == null) return null;

      // 2. Secure File Relocation (Crucial for GBV Privacy)
      // Moving file from temp gallery to internal app directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = "EV_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final File savedImage = await File(rawImage.path).copy(
        path.join(appDir.path, fileName),
      );

      // 3. Cleanup: Delete the temporary file from the public cache
      await File(rawImage.path).delete();

      Logger.log("Evidence secured at: ${savedImage.path}");
      return savedImage.path;
    } catch (e) {
      Logger.log("Media Acquisition Failed: $e");
      return null;
    }
  }
}
