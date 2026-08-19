import 'dart:io';
import 'package:dio/dio.dart';

class UploadVideoRequest {
  final List<File> videos;
  final String lang;

  UploadVideoRequest({
    required this.videos,
    this.lang = "EN",
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "videos": await Future.wait(
        videos.map(
              (file) => MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      ),
      "lang": lang,
    });
  }
}