// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

TeacherChatParentListingResponse applyForTravelTripResponseFromJson(String str) => TeacherChatParentListingResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(TeacherChatParentListingResponse data) => json.encode(data.toJson());

class TeacherChatParentListingResponse {
  bool? success;
  String? message;
  TeacherChatParentListingData? data;

  TeacherChatParentListingResponse({
    this.success,
    this.message,
    this.data,
  });

  TeacherChatParentListingResponse copyWith({
    bool? success,
    String? message,
    TeacherChatParentListingData? data,
  }) =>
      TeacherChatParentListingResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory TeacherChatParentListingResponse.fromJson(Map<String, dynamic> json) => TeacherChatParentListingResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : TeacherChatParentListingData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class TeacherChatParentListingData {
  Pagination? pagination;
  List<TeacherChatParentListing>? data;

  TeacherChatParentListingData({
    this.pagination,
    this.data,
  });

  TeacherChatParentListingData copyWith({
    Pagination? pagination,
    List<TeacherChatParentListing>? data,
  }) =>
      TeacherChatParentListingData(
        pagination: pagination ?? this.pagination,
        data: data ?? this.data,
      );

  factory TeacherChatParentListingData.fromJson(Map<String, dynamic> json) => TeacherChatParentListingData(
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    data: json["data"] == null ? [] : List<TeacherChatParentListing>.from(json["data"]!.map((x) => TeacherChatParentListing.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TeacherChatParentListing {
  String? parentId;
  String? parentSlug;
  String? email;
  String? firstName;
  String? lastName;
  String? profileLink;
  String? parentCode;

  TeacherChatParentListing({
    this.parentId,
    this.parentSlug,
    this.email,
    this.firstName,
    this.lastName,
    this.profileLink,
    this.parentCode,
  });

  TeacherChatParentListing copyWith({
    String? parentId,
    String? parentSlug,
    String? email,
    String? firstName,
    String? lastName,
    String? profileLink,
    String? parentCode,
  }) =>
      TeacherChatParentListing(
        parentId: parentId ?? this.parentId,
        parentSlug: parentSlug ?? this.parentSlug,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profileLink: profileLink ?? this.profileLink,
        parentCode: parentCode ?? this.parentCode,
      );

  factory TeacherChatParentListing.fromJson(Map<String, dynamic> json) => TeacherChatParentListing(
    parentId: json["parentId"],
    parentSlug: json["parentSlug"],
    email: json["email"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileLink: json["profileLink"],
    parentCode: json["parentCode"],
  );

  Map<String, dynamic> toJson() => {
    "parentId": parentId,
    "parentSlug": parentSlug,
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "profileLink": profileLink,
    "parentCode": parentCode,
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
