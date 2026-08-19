// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

AddStudentLeaveResponse applyForTravelTripResponseFromJson(String str) => AddStudentLeaveResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(AddStudentLeaveResponse data) => json.encode(data.toJson());

class AddStudentLeaveResponse {
  bool? success;
  String? message;
  Data? data;

  AddStudentLeaveResponse({
    this.success,
    this.message,
    this.data,
  });

  AddStudentLeaveResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      AddStudentLeaveResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory AddStudentLeaveResponse.fromJson(Map<String, dynamic> json) => AddStudentLeaveResponse(
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
  String? studentId;
  String? leaveType;
  String? startDate;
  String? endDate;
  int? totalDays;
  String? status;
  String? appliedAt;

  Data({
    this.id,
    this.studentId,
    this.leaveType,
    this.startDate,
    this.endDate,
    this.totalDays,
    this.status,
    this.appliedAt,
  });

  Data copyWith({
    String? id,
    String? studentId,
    String? leaveType,
    String? startDate,
    String? endDate,
    int? totalDays,
    String? status,
    String? appliedAt,
  }) =>
      Data(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        leaveType: leaveType ?? this.leaveType,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        totalDays: totalDays ?? this.totalDays,
        status: status ?? this.status,
        appliedAt: appliedAt ?? this.appliedAt,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    studentId: json["studentId"],
    leaveType: json["leaveType"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    totalDays: json["totalDays"],
    status: json["status"],
    appliedAt: json["appliedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "studentId": studentId,
    "leaveType": leaveType,
    "startDate": startDate,
    "endDate": endDate,
    "totalDays": totalDays,
    "status": status,
    "appliedAt": appliedAt,
  };
}
