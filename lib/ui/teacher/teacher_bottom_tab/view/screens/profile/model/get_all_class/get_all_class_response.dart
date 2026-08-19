// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

GetAllClassResponse applyForTravelTripResponseFromJson(String str) => GetAllClassResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(GetAllClassResponse data) => json.encode(data.toJson());

class GetAllClassResponse {
  bool? success;
  String? message;
  Data? data;

  GetAllClassResponse({
    this.success,
    this.message,
    this.data,
  });

  GetAllClassResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      GetAllClassResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory GetAllClassResponse.fromJson(Map<String, dynamic> json) => GetAllClassResponse(
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
  int? total;
  int? page;
  int? limit;
  List<Class>? classes;

  Data({
    this.total,
    this.page,
    this.limit,
    this.classes,
  });

  Data copyWith({
    int? total,
    int? page,
    int? limit,
    List<Class>? classes,
  }) =>
      Data(
        total: total ?? this.total,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        classes: classes ?? this.classes,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    classes: json["classes"] == null ? [] : List<Class>.from(json["classes"]!.map((x) => Class.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "classes": classes == null ? [] : List<dynamic>.from(classes!.map((x) => x.toJson())),
  };
}

class Class {
  String? id;
  String? slug;
  String? name;
  int? numberOfStudents;
  String? classCode;
  String? status;

  Class({
    this.id,
    this.slug,
    this.name,
    this.numberOfStudents,
    this.classCode,
    this.status,
  });

  Class copyWith({
    String? id,
    String? slug,
    String? name,
    int? numberOfStudents,
    String? classCode,
    String? status,
  }) =>
      Class(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        name: name ?? this.name,
        numberOfStudents: numberOfStudents ?? this.numberOfStudents,
        classCode: classCode ?? this.classCode,
        status: status ?? this.status,
      );

  factory Class.fromJson(Map<String, dynamic> json) => Class(
    id: json["id"],
    slug: json["slug"],
    name: json["name"],
    numberOfStudents: json["numberOfStudents"],
    classCode: json["classCode"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "name": name,
    "numberOfStudents": numberOfStudents,
    "classCode": classCode,
    "status": status,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Class) return false;
    if (id != null && other.id != null) return id == other.id;
    if (slug != null && other.slug != null) return slug == other.slug;
    return name == other.name;
  }

  @override
  int get hashCode => id?.hashCode ?? slug?.hashCode ?? name.hashCode;
}
