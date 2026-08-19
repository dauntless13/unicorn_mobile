// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

ActivityListingResponse applyForTravelTripResponseFromJson(String str) => ActivityListingResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(ActivityListingResponse data) => json.encode(data.toJson());

class ActivityListingResponse {
  bool? success;
  String? message;
  Data? data;

  ActivityListingResponse({
    this.success,
    this.message,
    this.data,
  });

  ActivityListingResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      ActivityListingResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ActivityListingResponse.fromJson(Map<String, dynamic> json) => ActivityListingResponse(
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
  String? studentId;
  int? activityCount;
  List<ActivityList>? activity;

  Data({
    this.studentId,
    this.activityCount,
    this.activity,
  });

  Data copyWith({
    String? studentId,
    int? activityCount,
    List<ActivityList>? activity,
  }) =>
      Data(
        studentId: studentId ?? this.studentId,
        activityCount: activityCount ?? this.activityCount,
        activity: activity ?? this.activity,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    studentId: json["studentId"],
    activityCount: json["activityCount"],
    activity: json["activity"] == null ? [] : List<ActivityList>.from(json["activity"]!.map((x) => ActivityList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "studentId": studentId,
    "activityCount": activityCount,
    "activity": activity == null ? [] : List<dynamic>.from(activity!.map((x) => x.toJson())),
  };
}

class ActivityList {
  String? activityId;
  String? studentId;
  String? type;
  ActivityData? data;

  ActivityList({
    this.activityId,
    this.studentId,
    this.type,
    this.data,
  });

  factory ActivityList.fromJson(Map<String, dynamic> json) => ActivityList(
    activityId: json["activityId"],
    studentId: json["studentId"],
    type: json["type"],
    data: json["data"] == null ? null : ActivityData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "activityId": activityId,
    "studentId": studentId,
    "type": type,
    "data": data?.toJson(),
  };
}

class ActivityData {
  DateTime? date;
  String? startTime;
  String? endTime;
  String? description;

  ActivityData({
    this.date,
    this.startTime,
    this.endTime,
    this.description,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) => ActivityData(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    startTime: json["startTime"],
    endTime: json["endTime"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "date": date?.toIso8601String(),
    "startTime": startTime,
    "endTime": endTime,
    "description": description,
  };
}

class Singing {
  DateTime? date;
  String? startTime;
  String? endTime;
  String? description;

  Singing({
    this.date,
    this.startTime,
    this.endTime,
    this.description,
  });

  Singing copyWith({
    DateTime? date,
    String? startTime,
    String? endTime,
    String? description,
  }) =>
      Singing(
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        description: description ?? this.description,
      );

  factory Singing.fromJson(Map<String, dynamic> json) => Singing(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    startTime: json["startTime"],
    endTime: json["endTime"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "startTime": startTime,
    "endTime": endTime,
    "description": description,
  };
}
