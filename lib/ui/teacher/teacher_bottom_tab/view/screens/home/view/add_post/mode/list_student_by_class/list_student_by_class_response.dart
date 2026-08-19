// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

ListStudentByClassResponse applyForTravelTripResponseFromJson(String str) =>
    ListStudentByClassResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(ListStudentByClassResponse data) =>
    json.encode(data.toJson());

class ListStudentByClassResponse {
  bool? success;
  String? message;
  Data? data;

  ListStudentByClassResponse({
    this.success,
    this.message,
    this.data,
  });

  ListStudentByClassResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      ListStudentByClassResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ListStudentByClassResponse.fromJson(Map<String, dynamic> json) =>
      ListStudentByClassResponse(
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
  String? classId;
  String? classSlug;
  String? className;
  int? totalStudents;
  List<StudentData>? students;

  Data({
    this.classId,
    this.classSlug,
    this.className,
    this.totalStudents,
    this.students,
  });

  Data copyWith({
    String? classId,
    String? classSlug,
    String? className,
    int? totalStudents,
    List<StudentData>? students,
  }) =>
      Data(
        classId: classId ?? this.classId,
        classSlug: classSlug ?? this.classSlug,
        className: className ?? this.className,
        totalStudents: totalStudents ?? this.totalStudents,
        students: students ?? this.students,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        classId: json["classId"],
        classSlug: json["classSlug"],
        className: json["className"],
        totalStudents: json["totalStudents"],
        students: json["students"] == null
            ? []
            : List<StudentData>.from(
                json["students"]!.map((x) => StudentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "classId": classId,
        "classSlug": classSlug,
        "className": className,
        "totalStudents": totalStudents,
        "students": students == null
            ? []
            : List<dynamic>.from(students!.map((x) => x.toJson())),
      };
}

class StudentData {
  String? firstName;
  String? lastName;
  String? profileLink;
  String? id;
  String? slug;
  String? rollNumber;
  String? checkIn;
  String? checkOut;

  StudentData({
    this.firstName,
    this.lastName,
    this.profileLink,
    this.id,
    this.slug,
    this.rollNumber,
    this.checkIn,
    this.checkOut,
  });

  StudentData copyWith({
    String? firstName,
    String? lastName,
    String? profileLink,
    String? id,
    String? slug,
    String? rollNumber,
    String? checkIn,
    String? checkOut,
  }) =>
      StudentData(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profileLink: profileLink ?? this.profileLink,
        id: id ?? this.id,
        slug: slug ?? this.slug,
        rollNumber: rollNumber ?? this.rollNumber,
      );

  factory StudentData.fromJson(Map<String, dynamic> json) => StudentData(
        firstName: json["firstName"],
        lastName: json["lastName"],
        profileLink: json["profileLink"],
        id: json["id"],
        slug: json["slug"],
        rollNumber: json["rollNumber"],
        checkIn: json["checkIn"],
        checkOut: json["checkOut"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "profileLink": profileLink,
        "id": id,
        "slug": slug,
        "rollNumber": rollNumber,
        "checkIn": checkIn,
        "checkOut": checkOut,
      };
}
