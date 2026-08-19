// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

UploadVideoResponse applyForTravelTripResponseFromJson(String str) => UploadVideoResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(UploadVideoResponse data) => json.encode(data.toJson());

class UploadVideoResponse {
  bool? success;
  String? message;
  Data? data;

  UploadVideoResponse({
    this.success,
    this.message,
    this.data,
  });

  UploadVideoResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      UploadVideoResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory UploadVideoResponse.fromJson(Map<String, dynamic> json) => UploadVideoResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  List<Video>? videos;
  int? count;

  Data({
    this.videos,
    this.count,
  });

  Data copyWith({
    List<Video>? videos,
    int? count,
  }) =>
      Data(
        videos: videos ?? this.videos,
        count: count ?? this.count,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    videos: json["videos"] == null ? [] : List<Video>.from(json["videos"]!.map((x) => Video.fromJson(x))),
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "videos": videos == null ? [] : List<dynamic>.from(videos!.map((x) => x.toJson())),
    "count": count,
  };
}

class Video {
  String? videoUrl;

  Video({
    this.videoUrl,
  });

  Video copyWith({
    String? videoUrl,
  }) =>
      Video(
        videoUrl: videoUrl ?? this.videoUrl,
      );

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    videoUrl: json["videoUrl"],
  );

  Map<String, dynamic> toJson() => {
    "videoUrl": videoUrl,
  };
}
