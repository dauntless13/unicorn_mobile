// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

AddStoryResponse applyForTravelTripResponseFromJson(String str) => AddStoryResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(AddStoryResponse data) => json.encode(data.toJson());

class AddStoryResponse {
  bool? success;
  String? message;
  Data? data;

  AddStoryResponse({
    this.success,
    this.message,
    this.data,
  });

  AddStoryResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      AddStoryResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory AddStoryResponse.fromJson(Map<String, dynamic> json) => AddStoryResponse(
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
  String? id;
  String? mediaUrl;
  String? mediaType;
  String? text;
  String? ctaText;
  DateTime? expiresAt;

  Data({
    this.id,
    this.mediaUrl,
    this.mediaType,
    this.text,
    this.ctaText,
    this.expiresAt,
  });

  Data copyWith({
    String? id,
    String? mediaUrl,
    String? mediaType,
    String? text,
    String? ctaText,
    DateTime? expiresAt,
  }) =>
      Data(
        id: id ?? this.id,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        mediaType: mediaType ?? this.mediaType,
        text: text ?? this.text,
        ctaText: ctaText ?? this.ctaText,
        expiresAt: expiresAt ?? this.expiresAt,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    mediaUrl: json["mediaUrl"],
    mediaType: json["mediaType"],
    text: json["text"],
    ctaText: json["ctaText"],
    expiresAt: json["expiresAt"] == null ? null : DateTime.parse(json["expiresAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mediaUrl": mediaUrl,
    "mediaType": mediaType,
    "text": text,
    "ctaText": ctaText,
    "expiresAt": expiresAt?.toIso8601String(),
  };
}
