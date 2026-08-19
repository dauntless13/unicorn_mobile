// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

AddNapResponse applyForTravelTripResponseFromJson(String str) => AddNapResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(AddNapResponse data) => json.encode(data.toJson());

class AddNapResponse {
  bool? success;
  String? message;
  NapData? data;

  AddNapResponse({
    this.success,
    this.message,
    this.data,
  });

  AddNapResponse copyWith({
    bool? success,
    String? message,
    NapData? data,
  }) =>
      AddNapResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory AddNapResponse.fromJson(Map<String, dynamic> json) => AddNapResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : NapData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class NapData {
  String? studentName;
  List<Nap>? naps;

  NapData({
    this.studentName,
    this.naps,
  });

  NapData copyWith({
    String? studentName,
    List<Nap>? naps,
  }) =>
      NapData(
        studentName: studentName ?? this.studentName,
        naps: naps ?? this.naps,
      );

  factory NapData.fromJson(Map<String, dynamic> json) => NapData(
    studentName: json["studentName"],
    naps: json["naps"] == null ? [] : List<Nap>.from(json["naps"]!.map((x) => Nap.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "studentName": studentName,
    "naps": naps == null ? [] : List<dynamic>.from(naps!.map((x) => x.toJson())),
  };
}

class Nap {
  DateTime? date;
  String? startTime;
  String? endTime;
  String? description;

  Nap({
    this.date,
    this.startTime,
    this.endTime,
    this.description,
  });

  Nap copyWith({
    DateTime? date,
    String? startTime,
    String? endTime,
    String? description,
  }) =>
      Nap(
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        description: description ?? this.description,
      );

  factory Nap.fromJson(Map<String, dynamic> json) => Nap(
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
