// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

TeacherHolidayEventListResponse applyForTravelTripResponseFromJson(String str) => TeacherHolidayEventListResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(TeacherHolidayEventListResponse data) => json.encode(data.toJson());

class TeacherHolidayEventListResponse {
  bool? success;
  String? message;
  TeacherHolidayEventListData? data;

  TeacherHolidayEventListResponse({
    this.success,
    this.message,
    this.data,
  });

  TeacherHolidayEventListResponse copyWith({
    bool? success,
    String? message,
    TeacherHolidayEventListData? data,
  }) =>
      TeacherHolidayEventListResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory TeacherHolidayEventListResponse.fromJson(Map<String, dynamic> json) => TeacherHolidayEventListResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : TeacherHolidayEventListData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class TeacherHolidayEventListData {
  int? total;
  int? page;
  int? limit;
  List<TeacherHolidayListElement>? list;

  TeacherHolidayEventListData({
    this.total,
    this.page,
    this.limit,
    this.list,
  });

  TeacherHolidayEventListData copyWith({
    int? total,
    int? page,
    int? limit,
    List<TeacherHolidayListElement>? list,
  }) =>
      TeacherHolidayEventListData(
        total: total ?? this.total,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        list: list ?? this.list,
      );

  factory TeacherHolidayEventListData.fromJson(Map<String, dynamic> json) => TeacherHolidayEventListData(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    list: json["list"] == null ? [] : List<TeacherHolidayListElement>.from(json["list"]!.map((x) => TeacherHolidayListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class TeacherHolidayListElement {
  String? id;
  String? type;
  bool? student;
  bool? teacher;
  String? name;
  String? description;
  String? time;
  String? startDate;
  String? endDate;

  TeacherHolidayListElement({
    this.id,
    this.type,
    this.student,
    this.teacher,
    this.name,
    this.description,
    this.time,
    this.startDate,
    this.endDate,
  });

  TeacherHolidayListElement copyWith({
    String? id,
    String? type,
    bool? student,
    bool? teacher,
    String? name,
    String? description,
    String? time,
    String? startDate,
    String? endDate,
  }) =>
      TeacherHolidayListElement(
        id: id ?? this.id,
        type: type ?? this.type,
        student: student ?? this.student,
        teacher: teacher ?? this.teacher,
        name: name ?? this.name,
        description: description ?? this.description,
        time: time ?? this.time,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );

  factory TeacherHolidayListElement.fromJson(Map<String, dynamic> json) => TeacherHolidayListElement(
    id: json["id"],
    type: json["type"],
    student: json["student"],
    teacher: json["teacher"],
    name: json["name"],
    description: json["description"],
    time: json["time"],
    startDate: json["startDate"],
    endDate: json["endDate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "student": student,
    "teacher": teacher,
    "name": name,
    "description": description,
    "time": time,
    "startDate": startDate,
    "endDate": endDate,
  };
}
