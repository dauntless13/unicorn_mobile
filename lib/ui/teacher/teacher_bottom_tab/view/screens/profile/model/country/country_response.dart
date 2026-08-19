// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

CountryResponse applyForTravelTripResponseFromJson(String str) => CountryResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(CountryResponse data) => json.encode(data.toJson());

class CountryResponse {
  bool? success;
  String? message;
  Data? data;

  CountryResponse({
    this.success,
    this.message,
    this.data,
  });

  CountryResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      CountryResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory CountryResponse.fromJson(Map<String, dynamic> json) => CountryResponse(
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
  List<CountryData>? countries;

  Data({
    this.pagination,
    this.countries,
  });

  Data copyWith({
    Pagination? pagination,
    List<CountryData>? countries,
  }) =>
      Data(
        pagination: pagination ?? this.pagination,
        countries: countries ?? this.countries,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    countries: json["countries"] == null ? [] : List<CountryData>.from(json["countries"]!.map((x) => CountryData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination?.toJson(),
    "countries": countries == null ? [] : List<dynamic>.from(countries!.map((x) => x.toJson())),
  };
}

class CountryData {
  String? id;
  String? name;

  CountryData({
    this.id,
    this.name,
  });

  CountryData copyWith({
    String? id,
    String? name,
  }) =>
      CountryData(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
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
