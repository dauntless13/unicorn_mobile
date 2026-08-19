// To parse this JSON data, do
//
//     final couponsGetByIdResponse = couponsGetByIdResponseFromJson(jsonString);

import 'dart:convert';

TeacherProfileResponse couponsGetByIdResponseFromJson(String str) =>
    TeacherProfileResponse.fromJson(json.decode(str));

String couponsGetByIdResponseToJson(TeacherProfileResponse data) =>
    json.encode(data.toJson());

class TeacherProfileResponse {
  bool? success;
  String? message;
  TeacherProfileData? data;

  TeacherProfileResponse({
    this.success,
    this.message,
    this.data,
  });

  TeacherProfileResponse copyWith({
    bool? success,
    String? message,
    TeacherProfileData? data,
  }) =>
      TeacherProfileResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory TeacherProfileResponse.fromJson(Map<String, dynamic> json) =>
      TeacherProfileResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : TeacherProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class TeacherProfileData {
  String? id;
  String? teacherCode;
  String? profileLink;
  String? nurseryLogo;
  String? nurseryName;
  String? nurseryId;
  String? status;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? subject;
  String? slug;
  String? country;
  String? state;
  String? city;
  String? zipCode;
  String? address;
  String? education;
  int? experience;
  Urls? urls;
  List<String>? classes;

  TeacherProfileData({
    this.id,
    this.teacherCode,
    this.profileLink,
    this.nurseryLogo,
    this.nurseryName,
    this.nurseryId,
    this.status,
    this.firstName,
    this.lastName,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.subject,
    this.slug,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.address,
    this.education,
    this.experience,
    this.urls,
    this.classes,
  });

  TeacherProfileData copyWith({
    String? id,
    String? teacherCode,
    String? profileLink,
    String? nurseryLogo,
    String? nurseryName,
    String? nurseryId,
    String? status,
    String? firstName,
    String? lastName,
    String? email,
    String? countryCode,
    String? phoneNumber,
    String? subject,
    String? slug,
    String? country,
    String? state,
    String? city,
    String? zipCode,
    String? address,
    String? education,
    int? experience,
    Urls? urls,
    List<String>? classes,
  }) =>
      TeacherProfileData(
        id: id ?? this.id,
        teacherCode: teacherCode ?? this.teacherCode,
        profileLink: profileLink ?? this.profileLink,
        nurseryLogo: profileLink ?? this.nurseryLogo,
        nurseryName: profileLink ?? this.nurseryName,
        nurseryId: nurseryId ?? this.nurseryId,
        status: status ?? this.status,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        countryCode: countryCode ?? this.countryCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        subject: subject ?? this.subject,
        slug: slug ?? this.slug,
        country: country ?? this.country,
        state: state ?? this.state,
        city: city ?? this.city,
        zipCode: zipCode ?? this.zipCode,
        address: address ?? this.address,
        education: education ?? this.education,
        experience: experience ?? this.experience,
        urls: urls ?? this.urls,
        classes: classes ?? this.classes,
      );

  factory TeacherProfileData.fromJson(Map<String, dynamic> json) =>
      TeacherProfileData(
        id: json["id"],
        teacherCode: json["teacherCode"],
        profileLink: json["profileLink"],
        nurseryLogo: json["nurseryLogo"],
        nurseryName: json["nurseryName"],
        nurseryId: json["nurseryId"],
        status: json["status"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        countryCode: json["countryCode"],
        phoneNumber: json["phoneNumber"],
        subject: json["subject"],
        slug: json["slug"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        zipCode: json["zipCode"],
        address: json["address"],
        education: json["education"],
        experience: json["experience"],
        urls: json["urls"] == null ? null : Urls.fromJson(json["urls"]),
        classes: json["classes"] == null
            ? []
            : List<String>.from(json["classes"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "teacherCode": teacherCode,
        "profileLink": profileLink,
        "nurseryLogo": nurseryLogo,
        "nurseryName": nurseryName,
        "nurseryId": nurseryId,
        "status": status,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "countryCode": countryCode,
        "phoneNumber": phoneNumber,
        "subject": subject,
        "slug": slug,
        "country": country,
        "state": state,
        "city": city,
        "zipCode": zipCode,
        "address": address,
        "education": education,
        "experience": experience,
        "urls": urls?.toJson(),
        "classes":
            classes == null ? [] : List<dynamic>.from(classes!.map((x) => x)),
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
