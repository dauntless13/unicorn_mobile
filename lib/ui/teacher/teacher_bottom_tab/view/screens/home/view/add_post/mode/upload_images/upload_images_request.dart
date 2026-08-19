import 'dart:io';
import 'package:dio/dio.dart';

// class UploadImagesRequest {
//   final File image;
//   final String lang;
//
//   UploadImagesRequest({
//     required this.image,
//     this.lang = "EN",
//   });
//
//   Future<FormData> toFormData() async {
//     return FormData.fromMap({
//       "images": await MultipartFile.fromFile(
//         image.path,
//         filename: image.path.split('/').last,
//       ),
//       "lang": lang,
//     });
//   }
// }

class UploadImagesRequest {
  final List<File> images;
  final String lang;

  UploadImagesRequest({
    required this.images,
    this.lang = "EN",
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "images": [
        for (File file in images)
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
      ],
      "lang": lang,
    });
  }
}