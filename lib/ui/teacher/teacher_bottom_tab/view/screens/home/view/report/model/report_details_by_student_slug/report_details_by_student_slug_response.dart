// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

ReportDetailsByStudentSlugResponse applyForTravelTripResponseFromJson(
        String str) =>
    ReportDetailsByStudentSlugResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(
        ReportDetailsByStudentSlugResponse data) =>
    json.encode(data.toJson());

class ReportDetailsByStudentSlugResponse {
  bool? success;
  String? message;
  StudentReportDetailsData? data;

  ReportDetailsByStudentSlugResponse({
    this.success,
    this.message,
    this.data,
  });

  ReportDetailsByStudentSlugResponse copyWith({
    bool? success,
    String? message,
    StudentReportDetailsData? data,
  }) =>
      ReportDetailsByStudentSlugResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ReportDetailsByStudentSlugResponse.fromJson(
          Map<String, dynamic> json) =>
      ReportDetailsByStudentSlugResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : StudentReportDetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class StudentReportDetailsData {
  String? name;
  String? roll;
  String? profileLink;
  String? className;
  DateTime? date;
  TodaysMood? todaysMood;
  List<MealsAndSnack>? mealsAndSnacks;
  List<Hygiene>? hygiene;
  List<Nap>? nap;
  List<Activity>? activity;
  List<Note>? note;
  Attendance? attendance;
  String? reportPdfLink;

  StudentReportDetailsData({
    this.name,
    this.roll,
    this.profileLink,
    this.className,
    this.date,
    this.todaysMood,
    this.mealsAndSnacks,
    this.hygiene,
    this.nap,
    this.activity,
    this.note,
    this.attendance,
    this.reportPdfLink,
  });

  StudentReportDetailsData copyWith({
    String? name,
    String? roll,
    String? profileLink,
    String? className,
    DateTime? date,
    TodaysMood? todaysMood,
    List<MealsAndSnack>? mealsAndSnacks,
    List<Hygiene>? hygiene,
    List<Nap>? nap,
    List<Activity>? activity,
    List<Note>? note,
    Attendance? attendance,
    String? reportPdfLink,
  }) =>
      StudentReportDetailsData(
        name: name ?? this.name,
        roll: roll ?? this.roll,
        profileLink: profileLink ?? this.profileLink,
        className: className ?? this.className,
        date: date ?? this.date,
        todaysMood: todaysMood ?? this.todaysMood,
        mealsAndSnacks: mealsAndSnacks ?? this.mealsAndSnacks,
        hygiene: hygiene ?? this.hygiene,
        nap: nap ?? this.nap,
        activity: activity ?? this.activity,
        note: note ?? this.note,
        attendance: attendance ?? this.attendance,
        reportPdfLink: reportPdfLink ?? this.reportPdfLink,
      );

  factory StudentReportDetailsData.fromJson(Map<String, dynamic> json) =>
      StudentReportDetailsData(
        name: json["name"],
        roll: json["roll"],
        profileLink: json["profileLink"],
        className: json["className"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        todaysMood: json["todaysMood"] == null
            ? null
            : TodaysMood.fromJson(json["todaysMood"]),
        mealsAndSnacks: json["mealsAndSnacks"] == null
            ? []
            : List<MealsAndSnack>.from(
                json["mealsAndSnacks"]!.map((x) => MealsAndSnack.fromJson(x))),
        hygiene: json["hygiene"] == null
            ? []
            : List<Hygiene>.from(
                json["hygiene"]!.map((x) => Hygiene.fromJson(x))),
        nap: json["nap"] == null
            ? []
            : List<Nap>.from(json["nap"]!.map((x) => Nap.fromJson(x))),
        activity: json["activity"] == null
            ? []
            : List<Activity>.from(
                json["activity"]!.map((x) => Activity.fromJson(x))),
        note: json["note"] == null
            ? []
            : List<Note>.from(json["note"]!.map((x) => Note.fromJson(x))),
        attendance: json["attendance"] == null
            ? null
            : Attendance.fromJson(json["attendance"]),
        reportPdfLink: json["reportPdfLink"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "roll": roll,
        "profileLink": profileLink,
        "className": className,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "todaysMood": todaysMood?.toJson(),
        "mealsAndSnacks": mealsAndSnacks == null
            ? []
            : List<dynamic>.from(mealsAndSnacks!.map((x) => x.toJson())),
        "hygiene": hygiene == null
            ? []
            : List<dynamic>.from(hygiene!.map((x) => x.toJson())),
        "nap":
            nap == null ? [] : List<dynamic>.from(nap!.map((x) => x.toJson())),
        "activity": activity == null
            ? []
            : List<dynamic>.from(activity!.map((x) => x.toJson())),
        "note": note == null
            ? []
            : List<dynamic>.from(note!.map((x) => x.toJson())),
        "attendance": attendance?.toJson(),
        "reportPdfLink": reportPdfLink,
      };
}

class Attendance {
  String? date;
  String? checkIn;
  String? checkOut;

  Attendance({
    this.date,
    this.checkIn,
    this.checkOut,
  });

  Attendance copyWith({
    String? date,
    String? checkIn,
    String? checkOut,
  }) =>
      Attendance(
        date: date ?? this.date,
        checkIn: checkIn ?? this.checkIn,
        checkOut: checkOut ?? this.checkOut,
      );

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        date: json["date"],
        checkIn: json["checkIn"],
        checkOut: json["checkOut"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "checkIn": checkIn,
        "checkOut": checkOut,
      };
}

class Activity {
  String? activityId;
  String? activityType;
  String? startTime;
  String? endTime;
  String? description;

  Activity({
    this.activityId,
    this.activityType,
    this.startTime,
    this.endTime,
    this.description,
  });

  Activity copyWith({
    String? activityId,
    String? activityType,
    String? startTime,
    String? endTime,
    String? description,
  }) =>
      Activity(
        activityId: activityId ?? this.activityId,
        activityType: activityType ?? this.activityType,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        description: description ?? this.description,
      );

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        activityId: json["activityId"],
        activityType: json["activityType"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "activityType": activityType,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
      };
}

class Hygiene {
  String? hygieneId;
  String? hygieneType;
  String? time;
  String? description;

  Hygiene({
    this.hygieneId,
    this.hygieneType,
    this.time,
    this.description,
  });

  Hygiene copyWith({
    String? hygieneId,
    String? hygieneType,
    String? time,
    String? description,
  }) =>
      Hygiene(
        hygieneId: hygieneId ?? this.hygieneId,
        hygieneType: hygieneType ?? this.hygieneType,
        time: time ?? this.time,
        description: description ?? this.description,
      );

  factory Hygiene.fromJson(Map<String, dynamic> json) => Hygiene(
        hygieneId: json["hygieneId"],
        hygieneType: json["hygieneType"] ?? json["hygiene_type"],
        time: json["time"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "hygieneId": hygieneId,
        "hygieneType": hygieneType,
        "time": time,
        "description": description,
      };
}

class MealsAndSnack {
  String? mealId;
  String? mealName;
  String? portion;
  String? time;
  String? description;

  MealsAndSnack({
    this.mealId,
    this.mealName,
    this.portion,
    this.time,
    this.description,
  });

  MealsAndSnack copyWith({
    String? mealId,
    String? mealName,
    String? portion,
    String? time,
    String? description,
  }) =>
      MealsAndSnack(
        mealId: mealId ?? this.mealId,
        mealName: mealName ?? this.mealName,
        portion: portion ?? this.portion,
        time: time ?? this.time,
        description: description ?? this.description,
      );

  factory MealsAndSnack.fromJson(Map<String, dynamic> json) => MealsAndSnack(
        mealId: json["mealId"],
        mealName: json["mealName"],
        portion: json["portion"],
        time: json["time"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "mealId": mealId,
        "mealName": mealName,
        "portion": portion,
        "time": time,
        "description": description,
      };
}

class Nap {
  String? napId;
  String? startTime;
  String? endTime;
  String? description;

  Nap({
    this.napId,
    this.startTime,
    this.endTime,
    this.description,
  });

  Nap copyWith({
    String? napId,
    String? startTime,
    String? endTime,
    String? description,
  }) =>
      Nap(
        napId: napId ?? this.napId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        description: description ?? this.description,
      );

  factory Nap.fromJson(Map<String, dynamic> json) => Nap(
        napId: json["napId"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "napId": napId,
        "startTime": startTime,
        "endTime": endTime,
        "description": description,
      };
}

class Note {
  String? noteId;
  String? content;

  Note({
    this.noteId,
    this.content,
  });

  Note copyWith({
    String? noteId,
    String? content,
  }) =>
      Note(
        noteId: noteId ?? this.noteId,
        content: content ?? this.content,
      );

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        noteId: json["noteId"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "noteId": noteId,
        "content": content,
      };
}

class TodaysMood {
  List<String>? mood;

  TodaysMood({
    this.mood,
  });

  TodaysMood copyWith({
    List<String>? mood,
  }) =>
      TodaysMood(
        mood: mood ?? this.mood,
      );

  factory TodaysMood.fromJson(Map<String, dynamic> json) => TodaysMood(
        mood: json["mood"] == null
            ? []
            : List<String>.from(json["mood"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "mood": mood == null ? [] : List<dynamic>.from(mood!.map((x) => x)),
      };
}
