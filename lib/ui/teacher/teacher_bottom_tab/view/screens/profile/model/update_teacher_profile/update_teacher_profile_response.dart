// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

UpdateTeacherProfileResponse applyForTravelTripResponseFromJson(String str) => UpdateTeacherProfileResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(UpdateTeacherProfileResponse data) => json.encode(data.toJson());

class UpdateTeacherProfileResponse {
  bool? success;
  String? message;
  Data? data;

  UpdateTeacherProfileResponse({
    this.success,
    this.message,
    this.data,
  });

  UpdateTeacherProfileResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      UpdateTeacherProfileResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory UpdateTeacherProfileResponse.fromJson(Map<String, dynamic> json) => UpdateTeacherProfileResponse(
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
  String? id;
  String? role;
  String? firstName;
  String? lastName;
  String? education;
  String? subject;
  int? experience;
  String? countryCode;
  String? phoneNumber;
  String? address;
  String? countryName;
  String? stateName;
  String? cityName;
  String? zipCode;
  String? profileLink;
  List<String>? classNames;

  Data({
    this.id,
    this.role,
    this.firstName,
    this.lastName,
    this.education,
    this.subject,
    this.experience,
    this.countryCode,
    this.phoneNumber,
    this.address,
    this.countryName,
    this.stateName,
    this.cityName,
    this.zipCode,
    this.profileLink,
    this.classNames,
  });

  Data copyWith({
    String? id,
    String? role,
    String? firstName,
    String? lastName,
    String? education,
    String? subject,
    int? experience,
    String? countryCode,
    String? phoneNumber,
    String? address,
    String? countryName,
    String? stateName,
    String? cityName,
    String? zipCode,
    String? profileLink,
    List<String>? classNames,
  }) =>
      Data(
        id: id ?? this.id,
        role: role ?? this.role,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        education: education ?? this.education,
        subject: subject ?? this.subject,
        experience: experience ?? this.experience,
        countryCode: countryCode ?? this.countryCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        countryName: countryName ?? this.countryName,
        stateName: stateName ?? this.stateName,
        cityName: cityName ?? this.cityName,
        zipCode: zipCode ?? this.zipCode,
        profileLink: profileLink ?? this.profileLink,
        classNames: classNames ?? this.classNames,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    role: json["role"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    education: json["education"],
    subject: json["subject"],
    experience: json["experience"],
    countryCode: json["countryCode"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    countryName: json["countryName"],
    stateName: json["stateName"],
    cityName: json["cityName"],
    zipCode: json["zipCode"],
    profileLink: json["profileLink"],
    classNames: json["classNames"] == null ? [] : List<String>.from(json["classNames"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role": role,
    "firstName": firstName,
    "lastName": lastName,
    "education": education,
    "subject": subject,
    "experience": experience,
    "countryCode": countryCode,
    "phoneNumber": phoneNumber,
    "address": address,
    "countryName": countryName,
    "stateName": stateName,
    "cityName": cityName,
    "zipCode": zipCode,
    "profileLink": profileLink,
    "classNames": classNames == null ? [] : List<dynamic>.from(classNames!.map((x) => x)),
  };
}
