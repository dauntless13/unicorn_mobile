// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

SavePostResponse applyForTravelTripResponseFromJson(String str) => SavePostResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(SavePostResponse data) => json.encode(data.toJson());

class SavePostResponse {
  bool? success;
  String? message;
  Data? data;

  SavePostResponse({
    this.success,
    this.message,
    this.data,
  });

  SavePostResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      SavePostResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory SavePostResponse.fromJson(Map<String, dynamic> json) => SavePostResponse(
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
  String? postSlug;
  String? postId;
  String? parentId;
  String? userId;
  String? role;
  String? slug;
  String? firstName;
  String? lastName;
  String? profileLink;

  Data({
    this.postSlug,
    this.postId,
    this.parentId,
    this.userId,
    this.role,
    this.slug,
    this.firstName,
    this.lastName,
    this.profileLink,
  });

  Data copyWith({
    String? postSlug,
    String? postId,
    String? parentId,
    String? userId,
    String? role,
    String? slug,
    String? firstName,
    String? lastName,
    String? profileLink,
  }) =>
      Data(
        postSlug: postSlug ?? this.postSlug,
        postId: postId ?? this.postId,
        parentId: parentId ?? this.parentId,
        userId: userId ?? this.userId,
        role: role ?? this.role,
        slug: slug ?? this.slug,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profileLink: profileLink ?? this.profileLink,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    postSlug: json["postSlug"],
    postId: json["postId"],
    parentId: json["parentId"],
    userId: json["userId"],
    role: json["role"],
    slug: json["slug"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileLink: json["profileLink"],
  );

  Map<String, dynamic> toJson() => {
    "postSlug": postSlug,
    "postId": postId,
    "parentId": parentId,
    "userId": userId,
    "role": role,
    "slug": slug,
    "firstName": firstName,
    "lastName": lastName,
    "profileLink": profileLink,
  };
}
