// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

ParentListingResponse applyForTravelTripResponseFromJson(String str) => ParentListingResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(ParentListingResponse data) => json.encode(data.toJson());

class ParentListingResponse {
  bool? success;
  String? message;
  Data? data;

  ParentListingResponse({
    this.success,
    this.message,
    this.data,
  });

  ParentListingResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      ParentListingResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ParentListingResponse.fromJson(Map<String, dynamic> json) => ParentListingResponse(
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
  String? parentCode;
  String? slug;
  String? firstName;
  String? lastName;
  String? profileLink;
  DateTime? createdAt;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? address;
  String? zipcode;
  String? country;
  String? state;
  String? city;
  String? education;
  String? occupation;
  List<Student>? students;

  Datum({
    this.id,
    this.parentCode,
    this.slug,
    this.firstName,
    this.lastName,
    this.profileLink,
    this.createdAt,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.address,
    this.zipcode,
    this.country,
    this.state,
    this.city,
    this.education,
    this.occupation,
    this.students,
  });

  Datum copyWith({
    String? id,
    String? parentCode,
    String? slug,
    String? firstName,
    String? lastName,
    String? profileLink,
    DateTime? createdAt,
    String? email,
    String? countryCode,
    String? phoneNumber,
    String? address,
    String? zipcode,
    String? country,
    String? state,
    String? city,
    String? education,
    String? occupation,
    List<Student>? students,
  }) =>
      Datum(
        id: id ?? this.id,
        parentCode: parentCode ?? this.parentCode,
        slug: slug ?? this.slug,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profileLink: profileLink ?? this.profileLink,
        createdAt: createdAt ?? this.createdAt,
        email: email ?? this.email,
        countryCode: countryCode ?? this.countryCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        zipcode: zipcode ?? this.zipcode,
        country: country ?? this.country,
        state: state ?? this.state,
        city: city ?? this.city,
        education: education ?? this.education,
        occupation: occupation ?? this.occupation,
        students: students ?? this.students,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    parentCode: json["parentCode"],
    slug: json["slug"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileLink: json["profileLink"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    email: json["email"],
    countryCode: json["countryCode"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    zipcode: json["zipcode"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    education: json["education"],
    occupation: json["occupation"],
    students: json["students"] == null ? [] : List<Student>.from(json["students"]!.map((x) => Student.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parentCode": parentCode,
    "slug": slug,
    "firstName": firstName,
    "lastName": lastName,
    "profileLink": profileLink,
    "createdAt": "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
    "email": email,
    "countryCode": countryCode,
    "phoneNumber": phoneNumber,
    "address": address,
    "zipcode": zipcode,
    "country": country,
    "state": state,
    "city": city,
    "education": education,
    "occupation": occupation,
    "students": students == null ? [] : List<dynamic>.from(students!.map((x) => x.toJson())),
  };
}

class Student {
  String? name;
  String? roll;
  String? studentClass;
  String? profileLink;

  Student({
    this.name,
    this.roll,
    this.studentClass,
    this.profileLink,
  });

  Student copyWith({
    String? name,
    String? roll,
    String? studentClass,
    String? profileLink,
  }) =>
      Student(
        name: name ?? this.name,
        roll: roll ?? this.roll,
        studentClass: studentClass ?? this.studentClass,
        profileLink: profileLink ?? this.profileLink,
      );

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    name: json["name"],
    roll: json["roll"],
    studentClass: json["class"],
    profileLink: json["profileLink"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "roll": roll,
    "class": studentClass,
    "profileLink": profileLink,
  };
}
