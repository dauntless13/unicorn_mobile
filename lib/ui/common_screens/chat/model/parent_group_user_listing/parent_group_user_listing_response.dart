// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

ParentGroupUserListingResponse applyForTravelTripResponseFromJson(String str) => ParentGroupUserListingResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(ParentGroupUserListingResponse data) => json.encode(data.toJson());

class ParentGroupUserListingResponse {
  bool? success;
  String? message;
  ParentGroupUserListingData? data;

  ParentGroupUserListingResponse({
    this.success,
    this.message,
    this.data,
  });

  ParentGroupUserListingResponse copyWith({
    bool? success,
    String? message,
    ParentGroupUserListingData? data,
  }) =>
      ParentGroupUserListingResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ParentGroupUserListingResponse.fromJson(Map<String, dynamic> json) => ParentGroupUserListingResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ParentGroupUserListingData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ParentGroupUserListingData {
  Group? group;
  Pagination? pagination;
  List<ParentGroupUserListing>? data;

  ParentGroupUserListingData({
    this.group,
    this.pagination,
    this.data,
  });

  ParentGroupUserListingData copyWith({
    Group? group,
    Pagination? pagination,
    List<ParentGroupUserListing>? data,
  }) =>
      ParentGroupUserListingData(
        group: group ?? this.group,
        pagination: pagination ?? this.pagination,
        data: data ?? this.data,
      );

  factory ParentGroupUserListingData.fromJson(Map<String, dynamic> json) => ParentGroupUserListingData(
    group: json["group"] == null ? null : Group.fromJson(json["group"]),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    data: json["data"] == null ? [] : List<ParentGroupUserListing>.from(json["data"]!.map((x) => ParentGroupUserListing.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "group": group?.toJson(),
    "pagination": pagination?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ParentGroupUserListing {
  String? id;
  String? slug;
  String? email;
  String? name;
  String? profileLink;
  bool? inGroup;

  ParentGroupUserListing({
    this.id,
    this.slug,
    this.email,
    this.name,
    this.profileLink,
    this.inGroup,
  });

  ParentGroupUserListing copyWith({
    String? id,
    String? slug,
    String? email,
    String? name,
    String? profileLink,
    bool? inGroup,
  }) =>
      ParentGroupUserListing(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        email: email ?? this.email,
        name: name ?? this.name,
        profileLink: profileLink ?? this.profileLink,
        inGroup: inGroup ?? this.inGroup,
      );

  factory ParentGroupUserListing.fromJson(Map<String, dynamic> json) => ParentGroupUserListing(
    id: json["id"],
    slug: json["slug"],
    email: json["email"],
    name: json["name"],
    profileLink: json["profileLink"],
    inGroup: json["inGroup"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "email": email,
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
