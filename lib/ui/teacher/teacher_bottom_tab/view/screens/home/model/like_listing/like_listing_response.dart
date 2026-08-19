// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

LikeListingResponse applyForTravelTripResponseFromJson(String str) => LikeListingResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(LikeListingResponse data) => json.encode(data.toJson());

class LikeListingResponse {
  bool? success;
  String? message;
  Data? data;

  LikeListingResponse({
    this.success,
    this.message,
    this.data,
  });

  LikeListingResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      LikeListingResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LikeListingResponse.fromJson(Map<String, dynamic> json) => LikeListingResponse(
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
  Pagination? pagination;
  int? totalLikes;
  List<LikeListing>? likes;

  Data({
    this.pagination,
    this.totalLikes,
    this.likes,
  });

  Data copyWith({
    Pagination? pagination,
    int? totalLikes,
    List<LikeListing>? likes,
  }) =>
      Data(
        pagination: pagination ?? this.pagination,
        totalLikes: totalLikes ?? this.totalLikes,
        likes: likes ?? this.likes,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    totalLikes: json["totalLikes"],
    likes: json["likes"] == null ? [] : List<LikeListing>.from(json["likes"]!.map((x) => LikeListing.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination?.toJson(),
    "totalLikes": totalLikes,
    "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x.toJson())),
  };
}

class LikeListing {
  String? id;
  String? slug;
  String? firstName;
  String? lastName;
  String? profileLink;

  LikeListing({
    this.id,
    this.slug,
    this.firstName,
    this.lastName,
    this.profileLink,
  });

  LikeListing copyWith({
    String? id,
    String? slug,
    String? firstName,
    String? lastName,
    String? profileLink,
  }) =>
      LikeListing(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profileLink: profileLink ?? this.profileLink,
      );

  factory LikeListing.fromJson(Map<String, dynamic> json) => LikeListing(
    id: json["id"],
    slug: json["slug"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileLink: json["profileLink"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "firstName": firstName,
    "lastName": lastName,
    "profileLink": profileLink,
  };
}

class Pagination {
  int? currentPage;
  int? pageSize;
  int? totalRecords;
  int? totalPages;

  Pagination({
    this.currentPage,
    this.pageSize,
    this.totalRecords,
    this.totalPages,
  });

  Pagination copyWith({
    int? currentPage,
    int? pageSize,
    int? totalRecords,
    int? totalPages,
  }) =>
      Pagination(
        currentPage: currentPage ?? this.currentPage,
        pageSize: pageSize ?? this.pageSize,
        totalRecords: totalRecords ?? this.totalRecords,
        totalPages: totalPages ?? this.totalPages,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["currentPage"],
    pageSize: json["pageSize"],
    totalRecords: json["totalRecords"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "currentPage": currentPage,
    "pageSize": pageSize,
    "totalRecords": totalRecords,
    "totalPages": totalPages,
  };
}
