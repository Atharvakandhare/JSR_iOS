// Implementation for mobile/desktop platforms
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> saveFile({
    required Uint8List bytes,
    required String fileName,
  }) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
        if (directory != null) {
          final downloadsPath = '${directory.path.split('Android')[0]}Download';
          directory = Directory(downloadsPath);
          if (!await directory.exists()) {
            directory = await getApplicationDocumentsDirectory();
          }
        } else {
          directory = await getApplicationDocumentsDirectory();
        }
      } else if (Platform.isIOS) {
        // iOS: Use application documents directory
        directory = await getApplicationDocumentsDirectory();
      } else {
        // Other platforms (desktop)
        directory = await getApplicationDocumentsDirectory();
      }
    } catch (e) {
      directory = await getApplicationDocumentsDirectory();
    }

    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  static bool get isAndroid => Platform.isAndroid;
}
