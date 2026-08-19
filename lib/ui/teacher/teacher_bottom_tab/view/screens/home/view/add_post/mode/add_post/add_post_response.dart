// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

AddPostResponse applyForTravelTripResponseFromJson(String str) => AddPostResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(AddPostResponse data) => json.encode(data.toJson());

class AddPostResponse {
  bool? success;
  String? message;
  Data? data;

  AddPostResponse({
    this.success,
    this.message,
    this.data,
  });

  AddPostResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      AddPostResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory AddPostResponse.fromJson(Map<String, dynamic> json) => AddPostResponse(
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
  String? slug;
  String? classId;
  String? type;
  String? mediaType;
  bool? isPublic;
  List<String>? mediaUrls;
  String? description;
  List<dynamic>? students;

  Data({
    this.id,
    this.slug,
    this.classId,
    this.type,
    this.mediaType,
    this.isPublic,
    this.mediaUrls,
    this.description,
    this.students,
  });

  Data copyWith({
    String? id,
    String? slug,
    String? classId,
    String? type,
    String? mediaType,
    bool? isPublic,
    List<String>? mediaUrls,
    String? description,
    List<dynamic>? students,
  }) =>
      Data(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        classId: classId ?? this.classId,
        type: type ?? this.type,
        mediaType: mediaType ?? this.mediaType,
        isPublic: isPublic ?? this.isPublic,
        mediaUrls: mediaUrls ?? this.mediaUrls,
        description: description ?? this.description,
        students: students ?? this.students,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    slug: json["slug"],
    classId: json["classId"],
    type: json["type"],
    mediaType: json["mediaType"],
    isPublic: json["isPublic"],
    mediaUrls: json["mediaUrls"] == null ? [] : List<String>.from(json["mediaUrls"]!.map((x) => x)),
    description: json["description"],
    students: json["students"] == null ? [] : List<dynamic>.from(json["students"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "classId": classId,
    "type": type,
    "mediaType": mediaType,
    "isPublic": isPublic,
    "mediaUrls": mediaUrls == null ? [] : List<dynamic>.from(mediaUrls!.map((x) => x)),
    "description": description,
    "students": students == null ? [] : List<dynamic>.from(students!.map((x) => x)),
  };
}
