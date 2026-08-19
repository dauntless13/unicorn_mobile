// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

TeacherGroupUserListingResponse applyForTravelTripResponseFromJson(String str) => TeacherGroupUserListingResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(TeacherGroupUserListingResponse data) => json.encode(data.toJson());

class TeacherGroupUserListingResponse {
  bool? success;
  String? message;
  TeacherGroupUserListingData? data;

  TeacherGroupUserListingResponse({
    this.success,
    this.message,
    this.data,
  });

  TeacherGroupUserListingResponse copyWith({
    bool? success,
    String? message,
    TeacherGroupUserListingData? data,
  }) =>
      TeacherGroupUserListingResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory TeacherGroupUserListingResponse.fromJson(Map<String, dynamic> json) => TeacherGroupUserListingResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : TeacherGroupUserListingData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class TeacherGroupUserListingData {
  Group? group;
  Pagination? pagination;
  List<TeacherGroupUserListing>? data;

  TeacherGroupUserListingData({
    this.group,
    this.pagination,
    this.data,
  });

  TeacherGroupUserListingData copyWith({
    Group? group,
    Pagination? pagination,
    List<TeacherGroupUserListing>? data,
  }) =>
      TeacherGroupUserListingData(
        group: group ?? this.group,
        pagination: pagination ?? this.pagination,
        data: data ?? this.data,
      );

  factory TeacherGroupUserListingData.fromJson(Map<String, dynamic> json) => TeacherGroupUserListingData(
    group: json["group"] == null ? null : Group.fromJson(json["group"]),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    data: json["data"] == null ? [] : List<TeacherGroupUserListing>.from(json["data"]!.map((x) => TeacherGroupUserListing.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "group": group?.toJson(),
    "pagination": pagination?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TeacherGroupUserListing {
  String? id;
  String? slug;
  String? name;
  String? profileLink;
  bool? inGroup;

  TeacherGroupUserListing({
    this.id,
    this.slug,
    this.name,
    this.profileLink,
    this.inGroup,
  });

  TeacherGroupUserListing copyWith({
    String? id,
    String? slug,
    String? name,
    String? profileLink,
    bool? inGroup,
  }) =>
      TeacherGroupUserListing(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        name: name ?? this.name,
        profileLink: profileLink ?? this.profileLink,
        inGroup: inGroup ?? this.inGroup,
      );

  factory TeacherGroupUserListing.fromJson(Map<String, dynamic> json) => TeacherGroupUserListing(
    id: json["id"],
    slug: json["slug"],
    name: json["name"],
    profileLink: json["profileLink"],
    inGroup: json["inGroup"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "name": name,
    "profileLink": profileLink,
    "inGroup": inGroup,
  };
}

class Group {
  String? id;
  String? slug;

  Group({
    this.id,
    this.slug,
  });

  Group copyWith({
    String? id,
    String? slug,
  }) =>
      Group(
        id: id ?? this.id,
        slug: slug ?? this.slug,
      );

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json["id"],
    slug: json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
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
