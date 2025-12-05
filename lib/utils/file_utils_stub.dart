// Stub file for web - file operations not supported
import 'dart:typed_data';

class FileUtils {
  static Future<String> saveFile({
    required Uint8List bytes,
    required String fileName,
  }) {
    throw UnsupportedError('File operations not supported on web');
  }

  static bool get isAndroid => false;
}



