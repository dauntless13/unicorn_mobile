import 'dart:convert';

TeacherLeaveListResponse teacherLeaveListResponseFromJson(String str) =>
    TeacherLeaveListResponse.fromJson(json.decode(str));

String teacherLeaveListResponseToJson(TeacherLeaveListResponse data) =>
    json.encode(data.toJson());

class TeacherLeaveListResponse {
  bool? success;
  String? message;
  TeacherLeaveListWrapper? data;

  TeacherLeaveListResponse({
    this.success,
    this.message,
    this.data,
  });

  factory TeacherLeaveListResponse.fromJson(Map<String, dynamic> json) =>
      TeacherLeaveListResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : TeacherLeaveListWrapper.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class TeacherLeaveListWrapper {
  Pagination? pagination;
  List<TeacherLeaveListData>? data;

  TeacherLeaveListWrapper({
    this.pagination,
    this.data,
  });

  factory TeacherLeaveListWrapper.fromJson(Map<String, dynamic> json) =>
      TeacherLeaveListWrapper(
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
        data: json["data"] == null
            ? []
            : List<TeacherLeaveListData>.from(
            json["data"].map((x) => TeacherLeaveListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "pagination": pagination?.toJson(),
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
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

class TeacherLeaveListData {
  String? id;
  String? teacherId;
  String? teacherCode;
  String? teacherName;
  String? profileLink;
  String? leaveType;
  String? startDate;
  String? endDate;
  int? totalDays;
  String? status;
  String? reason;
  String? appliedAt;
  String? approvedAt;

  TeacherLeaveListData({
    this.id,
    this.teacherId,
    this.teacherCode,
    this.teacherName,
    this.profileLink,
    this.leaveType,
    this.startDate,
    this.endDate,
    this.totalDays,
    this.status,
    this.reason,
    this.appliedAt,
    this.approvedAt,
  });

  factory TeacherLeaveListData.fromJson(Map<String, dynamic> json) =>
      TeacherLeaveListData(
        id: json["id"],
        teacherId: json["teacherId"],
        teacherCode: json["teacherCode"],
        teacherName: json["teacherName"],
        profileLink: json["profileLink"],
        leaveType: json["leaveType"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        totalDays: json["totalDays"],
        status: json["status"],
        reason: json["reason"],
        appliedAt: json["appliedAt"],
        approvedAt: json["approvedAt"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "teacherId": teacherId,
    "teacherCode": teacherCode,
    "teacherName": teacherName,
    "profileLink": profileLink,
    "leaveType": leaveType,
    "startDate": startDate,
    "endDate": endDate,
    "totalDays": totalDays,
    "status": status,
    "reason": reason,
    "appliedAt": appliedAt,
    "approvedAt": approvedAt,
  };
}