// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

StateResponse applyForTravelTripResponseFromJson(String str) => StateResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(StateResponse data) => json.encode(data.toJson());

class StateResponse {
  bool? success;
  String? message;
  Data? data;

  StateResponse({
    this.success,
    this.message,
    this.data,
  });

  StateResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      StateResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory StateResponse.fromJson(Map<String, dynamic> json) => StateResponse(
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
  Pagination? pagination;
  List<StateData>? states;

  Data({
    this.pagination,
    this.states,
  });

  Data copyWith({
    Pagination? pagination,
    List<StateData>? states,
  }) =>
      Data(
        pagination: pagination ?? this.pagination,
        states: states ?? this.states,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    states: json["states"] == null ? [] : List<StateData>.from(json["states"]!.map((x) => StateData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination?.toJson(),
    "states": states == null ? [] : List<dynamic>.from(states!.map((x) => x.toJson())),
  };
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Pagination({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  Pagination copyWith({
    int? total,
    int? page,
    int? limit,
    int? totalPages,
  }) =>
      Pagination(
        total: total ?? this.total,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        totalPages: totalPages ?? this.totalPages,
      );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
  };
}

class StateData {
  String? id;
  String? name;

  StateData({
    this.id,
    this.name,
  });

  StateData copyWith({
    String? id,
    String? name,
  }) =>
      StateData(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory StateData.fromJson(Map<String, dynamic> json) => StateData(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
