// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

StudentLeaveListingResponse applyForTravelTripResponseFromJson(String str) => StudentLeaveListingResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(StudentLeaveListingResponse data) => json.encode(data.toJson());

class StudentLeaveListingResponse {
  bool? success;
  String? message;
  Data? data;

  StudentLeaveListingResponse({
    this.success,
    this.message,
    this.data,
  });

  StudentLeaveListingResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      StudentLeaveListingResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StudentLeaveListingResponse.fromJson(Map<String, dynamic> json) => StudentLeaveListingResponse(
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
  List<Datum>? data;

  Data({
    this.pagination,
    this.data,
  });

  Data copyWith({
    Pagination? pagination,
    List<Datum>? data,
  }) =>
      Data(
        pagination: pagination ?? this.pagination,
        data: data ?? this.data,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? name;
  String? leaveFrom;
  String? leaveTo;
  String? leaveType;
  String? status;

  Datum({
    this.name,
    this.leaveFrom,
    this.leaveTo,
    this.leaveType,
    this.status,
  });

  Datum copyWith({
    String? name,
    String? leaveFrom,
    String? leaveTo,
    String? leaveType,
    String? status,
  }) =>
      Datum(
        name: name ?? this.name,
        leaveFrom: leaveFrom ?? this.leaveFrom,
        leaveTo: leaveTo ?? this.leaveTo,
        leaveType: leaveType ?? this.leaveType,
        status: status ?? this.status,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    leaveFrom: json["leaveFrom"],
    leaveTo: json["leaveTo"],
    leaveType: json["leaveType"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "leaveFrom": leaveFrom,
    "leaveTo": leaveTo,
    "leaveType": leaveType,
    "status": status,
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
