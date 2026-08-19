// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

NapListResponse applyForTravelTripResponseFromJson(String str) => NapListResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(NapListResponse data) => json.encode(data.toJson());

class NapListResponse {
  bool? success;
  String? message;
  NapListData? data;

  NapListResponse({
    this.success,
    this.message,
    this.data,
  });

  NapListResponse copyWith({
    bool? success,
    String? message,
    NapListData? data,
  }) =>
      NapListResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory NapListResponse.fromJson(Map<String, dynamic> json) => NapListResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : NapListData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class NapListData {
  String? studentName;
  List<NapList>? naps;

  NapListData({
    this.studentName,
    this.naps,
  });

  NapListData copyWith({
    String? studentName,
    List<NapList>? naps,
  }) =>
      NapListData(
        studentName: studentName ?? this.studentName,
        naps: naps ?? this.naps,
      );

  factory NapListData.fromJson(Map<String, dynamic> json) => NapListData(
    studentName: json["studentName"],
    naps: json["naps"] == null ? [] : List<NapList>.from(json["naps"]!.map((x) => NapList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "studentName": studentName,
    "naps": naps == null ? [] : List<dynamic>.from(naps!.map((x) => x.toJson())),
  };
}

class NapList {
  DateTime? date;
  String? startTime;
  String? endTime;
  String? description;

  NapList({
    this.date,
    this.startTime,
    this.endTime,
    this.description,
  });

  NapList copyWith({
    DateTime? date,
    String? startTime,
    String? endTime,
    String? description,
  }) =>
      NapList(
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        description: description ?? this.description,
      );

  factory NapList.fromJson(Map<String, dynamic> json) => NapList(
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
