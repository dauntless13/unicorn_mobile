// To parse this JSON data, do
//
//     final couponsGetByIdResponse = couponsGetByIdResponseFromJson(jsonString);

import 'dart:convert';

ParentDataBySlugResponse couponsGetByIdResponseFromJson(String str) =>
    ParentDataBySlugResponse.fromJson(json.decode(str));

String couponsGetByIdResponseToJson(ParentDataBySlugResponse data) =>
    json.encode(data.toJson());

class ParentDataBySlugResponse {
  bool? success;
  String? message;
  ParentData? data;

  ParentDataBySlugResponse({
    this.success,
    this.message,
    this.data,
  });

  ParentDataBySlugResponse copyWith({
    bool? success,
    String? message,
    ParentData? data,
  }) =>
      ParentDataBySlugResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ParentDataBySlugResponse.fromJson(Map<String, dynamic> json) =>
      ParentDataBySlugResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : ParentData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class ParentData {
  String? id;
  String? parentCode;
  String? firstName;
  String? lastName;
  String? profileLink;
  String? nurseryLogo;
  String? nurseryName;
  String? nurseryId;
  DateTime? createdAt;
  String? email;
  String? relationship; // ← NEW
  String? countryCode;
  String? phoneNumber;
  String? address;
  String? zipcode;
  String? country;
  String? state;
  String? city;
  String? education; // ← NEW
  String? occupation; // ← NEW
  Urls? urls;
  List<Student>? students;

  ParentData({
    this.id,
    this.parentCode,
    this.firstName,
    this.lastName,
    this.profileLink,
    this.nurseryLogo,
    this.nurseryName,
    this.nurseryId,
    this.createdAt,
    this.email,
    this.relationship,
    this.countryCode,
    this.phoneNumber,
    this.address,
    this.zipcode,
    this.country,
    this.state,
    this.city,
    this.education,
    this.occupation,
    this.urls,
    this.students,
  });

  ParentData copyWith({
    String? id,
    String? parentCode,
    String? firstName,
    String? lastName,
    String? profileLink,
    String? nurseryLogo,
    String? nurseryName,
    String? nurseryId,
    DateTime? createdAt,
    String? email,
    String? relationship,
    String? countryCode,
    String? phoneNumber,
    String? address,
    String? zipcode,
    String? country,
    String? state,
    String? city,
    String? education,
    String? occupation,
    Urls? urls,
    List<Student>? students,
  }) =>
      ParentData(
        id: id ?? this.id,
        parentCode: parentCode ?? this.parentCode,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profileLink: profileLink ?? this.profileLink,
        nurseryLogo: nurseryLogo ?? this.nurseryLogo,
        nurseryName: nurseryName ?? this.nurseryName,
        nurseryId: nurseryId ?? this.nurseryId,
        createdAt: createdAt ?? this.createdAt,
        email: email ?? this.email,
        relationship: relationship ?? this.relationship,
        countryCode: countryCode ?? this.countryCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        zipcode: zipcode ?? this.zipcode,
        country: country ?? this.country,
        state: state ?? this.state,
        city: city ?? this.city,
        education: education ?? this.education,
        occupation: occupation ?? this.occupation,
        urls: urls ?? this.urls,
        students: students ?? this.students,
      );

  factory ParentData.fromJson(Map<String, dynamic> json) => ParentData(
        id: json["id"],
        parentCode: json["parentCode"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        profileLink: json["profileLink"],
        nurseryLogo: json["nurseryLogo"],
        nurseryName: json["nurseryName"],
        nurseryId: json["nurseryId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        email: json["email"],
        relationship: json["relationship"],
        countryCode: json["countryCode"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        zipcode: json["zipcode"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        education: json["education"],
        occupation: json["occupation"],
        urls: json["urls"] == null ? null : Urls.fromJson(json["urls"]),
        students: json["students"] == null
            ? []
            : List<Student>.from(
                json["students"]!.map((x) => Student.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parentCode": parentCode,
        "firstName": firstName,
        "lastName": lastName,
        "profileLink": profileLink,
        "nurseryLogo": nurseryLogo,
        "nurseryName": nurseryName,
        "nurseryId": nurseryId,
        "createdAt": createdAt?.toIso8601String(),
        "email": email,
        "relationship": relationship,
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
        "address": address,
        "zipcode": zipcode,
        "country": country,
        "state": state,
        "city": city,
        "education": education,
        "occupation": occupation,
        "urls": urls?.toJson(),
        "students": students == null
            ? []
            : List<dynamic>.from(students!.map((x) => x.toJson())),
      };
}

class Student {
  String? id;
  String? studentId;
  String? name;
  String? roll;
  String? studentClass;
  String? profileLink;
  String? studentSlug;

  Student({
    this.id,
    this.studentId,
    this.name,
    this.roll,
    this.studentClass,
    this.profileLink,
    this.studentSlug,
  });

  Student copyWith({
    String? id,
    String? studentId,
    String? name,
    String? roll,
    String? studentClass,
    String? profileLink,
    String? studentSlug,
  }) =>
      Student(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        name: name ?? this.name,
        roll: roll ?? this.roll,
        studentClass: studentClass ?? this.studentClass,
        profileLink: profileLink ?? this.profileLink,
        studentSlug: studentSlug ?? this.studentSlug,
      );

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        studentId: json["studentId"] ?? json["student_id"],
        name: json["name"],
        roll: json["roll"],
        studentClass: json["class"],
        profileLink: json["profileLink"],
        studentSlug: json["studentSlug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "studentId": studentId,
        "name": name,
        "roll": roll,
        "class": studentClass,
        "profileLink": profileLink,
        "studentSlug": studentSlug,
      };
}

class Urls {
  String? copyrightUrl;
  String? privacyPolicyUrl;
  String? termsAndConditionsUrl;
  String? cancellationPolicyUrl;

  Urls({
    this.copyrightUrl,
    this.privacyPolicyUrl,
    this.termsAndConditionsUrl,
    this.cancellationPolicyUrl,
  });

  Urls copyWith({
    String? copyrightUrl,
    String? privacyPolicyUrl,
    String? termsAndConditionsUrl,
    String? cancellationPolicyUrl,
  }) =>
      Urls(
        copyrightUrl: copyrightUrl ?? this.copyrightUrl,
        privacyPolicyUrl: privacyPolicyUrl ?? this.privacyPolicyUrl,
        termsAndConditionsUrl:
            termsAndConditionsUrl ?? this.termsAndConditionsUrl,
        cancellationPolicyUrl:
            cancellationPolicyUrl ?? this.cancellationPolicyUrl,
      );

  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
        copyrightUrl: json["copyrightUrl"],
        privacyPolicyUrl: json["privacyPolicyUrl"],
        termsAndConditionsUrl: json["termsAndConditionsUrl"],
        cancellationPolicyUrl: json["cancellationPolicyUrl"],
      );

  Map<String, dynamic> toJson() => {
        "copyrightUrl": copyrightUrl,
        "privacyPolicyUrl": privacyPolicyUrl,
        "termsAndConditionsUrl": termsAndConditionsUrl,
        "cancellationPolicyUrl": cancellationPolicyUrl,
      };
}
