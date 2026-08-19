// To parse this JSON data, do
//
//     final studentNurseReportsResponse = studentNurseReportsResponseFromJson(jsonString);

import 'dart:convert';

StudentNurseReportsResponse studentNurseReportsResponseFromJson(String str) =>
    StudentNurseReportsResponse.fromJson(json.decode(str));

String studentNurseReportsResponseToJson(StudentNurseReportsResponse data) =>
    json.encode(data.toJson());

class StudentNurseReportsResponse {
  bool? success;
  String? message;
  Data? data;

  StudentNurseReportsResponse({
    this.success,
    this.message,
    this.data,
  });

  StudentNurseReportsResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      StudentNurseReportsResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StudentNurseReportsResponse.fromJson(Map<String, dynamic> json) =>
      StudentNurseReportsResponse(
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
  int? total;
  int? page;
  int? limit;
  Student? student;
  List<Datum>? data;

  Data({
    this.total,
    this.page,
    this.limit,
    this.student,
    this.data,
  });

  Data copyWith({
    int? total,
    int? page,
    int? limit,
    Student? student,
    List<Datum>? data,
  }) =>
      Data(
        total: total ?? this.total,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        student: student ?? this.student,
        data: data ?? this.data,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        student:
            json["student"] == null ? null : Student.fromJson(json["student"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "limit": limit,
        "student": student?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? id;
  String? title;
  DateTime? reportDate;
  String? reportText;
  String? classSlug;
  String? className;
  String? studentSlug;
  String? studentName;
  String? rollNumber;
  String? profileLink;
  String? nurseName;
  String? parentName;
  DateTime? createdAt;

  Datum({
    this.id,
    this.title,
    this.reportDate,
    this.reportText,
    this.classSlug,
    this.className,
    this.studentSlug,
    this.studentName,
    this.rollNumber,
    this.profileLink,
    this.nurseName,
    this.parentName,
    this.createdAt,
  });

  Datum copyWith({
    String? id,
    String? title,
    DateTime? reportDate,
    String? reportText,
    String? classSlug,
    String? className,
    String? studentSlug,
    String? studentName,
    String? rollNumber,
    String? profileLink,
    String? nurseName,
    String? parentName,
    DateTime? createdAt,
  }) =>
      Datum(
        id: id ?? this.id,
        title: title ?? this.title,
        reportDate: reportDate ?? this.reportDate,
        reportText: reportText ?? this.reportText,
        classSlug: classSlug ?? this.classSlug,
        className: className ?? this.className,
        studentSlug: studentSlug ?? this.studentSlug,
        studentName: studentName ?? this.studentName,
        rollNumber: rollNumber ?? this.rollNumber,
        profileLink: profileLink ?? this.profileLink,
        nurseName: nurseName ?? this.nurseName,
        parentName: parentName ?? this.parentName,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        reportDate: json["reportDate"] == null
            ? null
            : DateTime.parse(json["reportDate"]),
        reportText: json["reportText"],
        classSlug: json["classSlug"],
        className: json["className"],
        studentSlug: json["studentSlug"],
        studentName: json["studentName"],
        rollNumber: json["rollNumber"],
        profileLink: json["profileLink"],
        nurseName: json["nurseName"],
        parentName: json["parentName"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "reportDate":
            "${reportDate!.year.toString().padLeft(4, '0')}-${reportDate!.month.toString().padLeft(2, '0')}-${reportDate!.day.toString().padLeft(2, '0')}",
        "reportText": reportText,
        "classSlug": classSlug,
        "className": className,
        "studentSlug": studentSlug,
        "studentName": studentName,
        "rollNumber": rollNumber,
        "profileLink": profileLink,
        "nurseName": nurseName,
        "parentName": parentName,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class Student {
  String? slug;
  String? name;
  String? rollNumber;
  String? profileLink;
  String? className;
  String? parentName;

  Student({
    this.slug,
    this.name,
    this.rollNumber,
    this.profileLink,
    this.className,
    this.parentName,
  });

  Student copyWith({
    String? slug,
    String? name,
    String? rollNumber,
    String? profileLink,
    String? className,
    String? parentName,
  }) =>
      Student(
        slug: slug ?? this.slug,
        name: name ?? this.name,
        rollNumber: rollNumber ?? this.rollNumber,
        profileLink: profileLink ?? this.profileLink,
        className: className ?? this.className,
        parentName: parentName ?? this.parentName,
      );

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        slug: json["slug"],
        name: json["name"],
        rollNumber: json["rollNumber"],
        profileLink: json["profileLink"],
        className: json["className"],
        parentName: json["parentName"],
      );

  Map<String, dynamic> toJson() => {
        "slug": slug,
        "name": name,
        "rollNumber": rollNumber,
        "profileLink": profileLink,
        "className": className,
        "parentName": parentName,
      };
}
