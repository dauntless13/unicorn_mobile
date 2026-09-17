import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final root = Directory.current.path.contains('Unicorn-Nursery-App-version_1.0')
      ? Directory.current
      : Directory('Unicorn-Nursery-App-version_1.0');

  test('Android manifest strips Google Play photo/video read permissions', () {
    final manifest = File('${root.path}/android/app/src/main/AndroidManifest.xml');
    expect(manifest.existsSync(), isTrue);
    final text = manifest.readAsStringSync();

    for (final permission in const [
      'android.permission.READ_MEDIA_IMAGES',
      'android.permission.READ_MEDIA_VIDEO',
      'android.permission.READ_MEDIA_VISUAL_USER_SELECTED',
      'android.permission.READ_EXTERNAL_STORAGE',
    ]) {
      expect(
        text.contains('android:name="$permission"'),
        isTrue,
        reason: '$permission must be declared with tools:node="remove"',
      );
      expect(
        RegExp('android:name="$permission"[^>]*tools:node="remove"')
            .hasMatch(text),
        isTrue,
        reason: '$permission must be removed from the merged APK',
      );
    }
  });

  test('gallery picks go through AppMediaPicker, not raw ImagePicker', () {
    final lib = Directory('${root.path}/lib');
    final offenders = <String>[];
    for (final file in lib.listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart')) continue;
      if (file.path.replaceAll('\\', '/').endsWith('core/utils/android_media_access.dart')) {
        continue;
      }
      final text = file.readAsStringSync();
      if (text.contains('ImagePicker()') ||
          (text.contains("package:image_picker/image_picker.dart") &&
              !text.contains('AppMediaPicker'))) {
        offenders.add(file.path);
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'Use AppMediaPicker so Android always uses the system Photo Picker:\n${offenders.join('\n')}',
    );
  });
}
