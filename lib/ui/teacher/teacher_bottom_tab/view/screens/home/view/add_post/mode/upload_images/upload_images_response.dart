// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

UploadImagesResponse applyForTravelTripResponseFromJson(String str) => UploadImagesResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(UploadImagesResponse data) => json.encode(data.toJson());

class UploadImagesResponse {
  bool? success;
  String? message;
  Data? data;

  UploadImagesResponse({
    this.success,
    this.message,
    this.data,
  });

  UploadImagesResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      UploadImagesResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory UploadImagesResponse.fromJson(Map<String, dynamic> json) => UploadImagesResponse(
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
  List<Image>? images;
  int? count;

  Data({
    this.images,
    this.count,
  });

  Data copyWith({
    List<Image>? images,
    int? count,
  }) =>
      Data(
        images: images ?? this.images,
        count: count ?? this.count,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    "count": count,
  };
}

class Image {
  String? imageUrl;

  Image({
    this.imageUrl,
  });

  Image copyWith({
    String? imageUrl,
  }) =>
      Image(
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
  };
}
