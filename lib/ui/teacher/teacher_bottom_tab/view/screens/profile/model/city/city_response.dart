// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

CityResponse applyForTravelTripResponseFromJson(String str) => CityResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(CityResponse data) => json.encode(data.toJson());

class CityResponse {
  bool? success;
  String? message;
  Data? data;

  CityResponse({
    this.success,
    this.message,
    this.data,
  });

  CityResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      CityResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory CityResponse.fromJson(Map<String, dynamic> json) => CityResponse(
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
  List<City>? cities;

  Data({
    this.pagination,
    this.cities,
  });

  Data copyWith({
    Pagination? pagination,
    List<City>? cities,
  }) =>
      Data(
        pagination: pagination ?? this.pagination,
        cities: cities ?? this.cities,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    cities: json["cities"] == null ? [] : List<City>.from(json["cities"]!.map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination?.toJson(),
    "cities": cities == null ? [] : List<dynamic>.from(cities!.map((x) => x.toJson())),
  };
}

class City {
  String? id;
  String? name;

  City({
    this.id,
    this.name,
  });

  City copyWith({
    String? id,
    String? name,
  }) =>
      City(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
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
