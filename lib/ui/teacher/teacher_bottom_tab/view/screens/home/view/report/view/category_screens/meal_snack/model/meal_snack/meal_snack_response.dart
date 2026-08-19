// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

MealSnackResponse applyForTravelTripResponseFromJson(String str) => MealSnackResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(MealSnackResponse data) => json.encode(data.toJson());

class MealSnackResponse {
  bool? success;
  String? message;
  MealSnackData? data;

  MealSnackResponse({
    this.success,
    this.message,
    this.data,
  });

  MealSnackResponse copyWith({
    bool? success,
    String? message,
    MealSnackData? data,
  }) =>
      MealSnackResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory MealSnackResponse.fromJson(Map<String, dynamic> json) => MealSnackResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : MealSnackData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class MealSnackData {
  int? mealCount;
  String? studentId;
  List<MealList>? meals;

  MealSnackData({
    this.mealCount,
    this.studentId,
    this.meals,
  });

  MealSnackData copyWith({
    int? mealCount,
    String? studentId,
    List<MealList>? meals,
  }) =>
      MealSnackData(
        mealCount: mealCount ?? this.mealCount,
        studentId: studentId ?? this.studentId,
        meals: meals ?? this.meals,
      );

  factory MealSnackData.fromJson(Map<String, dynamic> json) => MealSnackData(
    mealCount: json["mealCount"],
    studentId: json["studentId"],
    meals: json["meals"] == null ? [] : List<MealList>.from(json["meals"]!.map((x) => MealList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "mealCount": mealCount,
    "studentId": studentId,
    "meals": meals == null ? [] : List<dynamic>.from(meals!.map((x) => x.toJson())),
  };
}

class MealList {
  String? mealId;
  String? studentId;
  String? mealName;
  DateTime? date;
  String? time;
  String? description;

  MealList({
    this.mealId,
    this.studentId,
    this.mealName,
    this.date,
    this.time,
    this.description,
  });

  MealList copyWith({
    String? mealId,
    String? studentId,
    String? mealName,
    DateTime? date,
    String? time,
    String? description,
  }) =>
      MealList(
        mealId: mealId ?? this.mealId,
        studentId: studentId ?? this.studentId,
        mealName: mealName ?? this.mealName,
        date: date ?? this.date,
        time: time ?? this.time,
        description: description ?? this.description,
      );

  factory MealList.fromJson(Map<String, dynamic> json) => MealList(
    mealId: json["mealId"],
    studentId: json["studentId"],
    mealName: json["mealName"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "mealId": mealId,
    "studentId": studentId,
    "mealName": mealName,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "time": time,
    "description": description,
  };
}
