import 'dart:typed_data';

import 'package:gal/gal.dart';

class GallerySaveHelper {
  static Future<bool> saveImageBytes(
    Uint8List bytes, {
    required String name,
  }) async {
    if (!await _ensureAccess()) return false;
    await Gal.putImageBytes(bytes, name: _stripExtension(name));
    return true;
  }

  static Future<bool> saveImageFile(String path, {String? name}) async {
    if (!await _ensureAccess()) return false;
    await Gal.putImage(path);
    return true;
  }

  static Future<bool> saveVideoFile(String path, {String? name}) async {
    if (!await _ensureAccess()) return false;
    await Gal.putVideo(path);
    return true;
  }

  static Future<bool> _ensureAccess() async {
    if (await Gal.hasAccess()) return true;
    return Gal.requestAccess();
  }

  static String _stripExtension(String name) {
    final trimmed = name.trim();
    final dot = trimmed.lastIndexOf('.');
    if (dot <= 0) return trimmed;
    return trimmed.substring(0, dot);
  }
}
