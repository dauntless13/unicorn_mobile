// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

LikePostResponse applyForTravelTripResponseFromJson(String str) => LikePostResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(LikePostResponse data) => json.encode(data.toJson());

class LikePostResponse {
  bool? success;
  String? message;
  Data? data;

  LikePostResponse({
    this.success,
    this.message,
    this.data,
  });

  LikePostResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      LikePostResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LikePostResponse.fromJson(Map<String, dynamic> json) => LikePostResponse(
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
  String? postId;
  bool? isLike;
  int? totalLikes;

  Data({
    this.postId,
    this.isLike,
    this.totalLikes,
  });

  Data copyWith({
    String? postId,
    bool? isLike,
    int? totalLikes,
  }) =>
      Data(
        postId: postId ?? this.postId,
        isLike: isLike ?? this.isLike,
        totalLikes: totalLikes ?? this.totalLikes,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    postId: json["postId"],
    isLike: json["isLike"],
    totalLikes: json["totalLikes"],
  );

  Map<String, dynamic> toJson() => {
    "postId": postId,
    "isLike": isLike,
    "totalLikes": totalLikes,
  };
}
