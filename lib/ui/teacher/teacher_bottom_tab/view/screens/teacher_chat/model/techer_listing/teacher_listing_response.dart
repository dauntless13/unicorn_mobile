// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

TeacherListingResponse applyForTravelTripResponseFromJson(String str) => TeacherListingResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(TeacherListingResponse data) => json.encode(data.toJson());

class TeacherListingResponse {
  bool? success;
  String? message;
  Data? data;

  TeacherListingResponse({
    this.success,
    this.message,
    this.data,
  });

  TeacherListingResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      TeacherListingResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory TeacherListingResponse.fromJson(Map<String, dynamic> json) => TeacherListingResponse(
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
  List<Datum>? data;

  Data({
    this.total,
    this.page,
    this.limit,
    this.data,
  });

  Data copyWith({
    int? total,
    int? page,
    int? limit,
    List<Datum>? data,
  }) =>
      Data(
        total: total ?? this.total,
        page: page ?? this.page,
        limit: limit ?? this.limit,
        data: data ?? this.data,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? teacherCode;
  String? status;
  String? firstName;
  String? lastName;
  String? profileLink;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? subject;
  String? education;
  int? experience;
  String? slug;
  String? country;
  String? state;
  String? city;
  String? zipCode;
  String? address;
  List<String>? classes;

  Datum({
    this.id,
    this.teacherCode,
    this.status,
    this.firstName,
    this.lastName,
    this.profileLink,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.subject,
    this.education,
    this.experience,
    this.slug,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.address,
    this.classes,
  });

  Datum copyWith({
    String? id,
    String? teacherCode,
    String? status,
    String? firstName,
    String? lastName,
    String? profileLink,
    String? email,
    String? countryCode,
    String? phoneNumber,
    String? subject,
    String? education,
    int? experience,
    String? slug,
    String? country,
    String? state,
    String? city,
    String? zipCode,
    String? address,
    List<String>? classes,
  }) =>
      Datum(
        id: id ?? this.id,
        teacherCode: teacherCode ?? this.teacherCode,
        status: status ?? this.status,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profileLink: profileLink ?? this.profileLink,
        email: email ?? this.email,
        countryCode: countryCode ?? this.countryCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        subject: subject ?? this.subject,
        education: education ?? this.education,
        experience: experience ?? this.experience,
        slug: slug ?? this.slug,
        country: country ?? this.country,
        state: state ?? this.state,
        city: city ?? this.city,
        zipCode: zipCode ?? this.zipCode,
        address: address ?? this.address,
        classes: classes ?? this.classes,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    teacherCode: json["teacherCode"],
    status: json["status"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileLink: json["profileLink"],
    email: json["email"],
    countryCode: json["countryCode"],
    phoneNumber: json["phoneNumber"],
    subject: json["subject"],
    education: json["education"],
    experience: json["experience"],
    slug: json["slug"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zipCode"],
    address: json["address"],
    classes: json["classes"] == null ? [] : List<String>.from(json["classes"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "teacherCode": teacherCode,
    "status": status,
    "firstName": firstName,
    "lastName": lastName,
    "profileLink": profileLink,
    "email": email,
    "countryCode": countryCode,
    "phoneNumber": phoneNumber,
    "subject": subject,
    "education": education,
    "experience": experience,
    "slug": slug,
    "country": country,
    "state": state,
    "city": city,
    "zipCode": zipCode,
    "address": address,
    "classes": classes == null ? [] : List<dynamic>.from(classes!.map((x) => x)),
  };
}
