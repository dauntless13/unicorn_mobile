// To parse this JSON data, do
//
//     final couponsGetByIdResponse = couponsGetByIdResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse couponsGetByIdResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String couponsGetByIdResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool? success;
  String? message;
  Data? data;

  LoginResponse({
    this.success,
    this.message,
    this.data,
  });

  LoginResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      LoginResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
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
  User? user;
  String? token;

  Data({
    this.user,
    this.token,
  });

  Data copyWith({
    User? user,
    String? token,
  }) =>
      Data(
        user: user ?? this.user,
        token: token ?? this.token,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
  };
}

class User {
  String? id;
  String? firstName;
  String? slug;
  String? lastName;
  String? emailAddress;
  String? role;
  String? lang;
  String? countryCode;
  String? phoneNumber;
  String? address;
  String? countryName;
  String? stateName;
  String? cityName;
  String? zipCode;
  String? profileLink;
  bool? evaluationEnabledForTeachers;
  bool? evaluationEnabledForParents;

  User({
    this.id,
    this.firstName,
    this.slug,
    this.lastName,
    this.emailAddress,
    this.role,
    this.lang,
    this.countryCode,
    this.phoneNumber,
    this.address,
    this.countryName,
    this.stateName,
    this.cityName,
    this.zipCode,
    this.profileLink,
    this.evaluationEnabledForTeachers,
    this.evaluationEnabledForParents,
  });

  User copyWith({
    String? id,
    String? firstName,
    String? slug,
    String? lastName,
    String? emailAddress,
    String? role,
    String? lang,
    String? countryCode,
    String? phoneNumber,
    String? address,
    String? countryName,
    String? stateName,
    String? cityName,
    String? zipCode,
    String? profileLink,
    bool? evaluationEnabledForTeachers,
    bool? evaluationEnabledForParents,
  }) =>
      User(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        emailAddress: emailAddress ?? this.emailAddress,
        role: role ?? this.role,
        lang: lang ?? this.lang,
        countryCode: countryCode ?? this.countryCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        countryName: countryName ?? this.countryName,
        stateName: stateName ?? this.stateName,
        cityName: cityName ?? this.cityName,
        zipCode: zipCode ?? this.zipCode,
        profileLink: profileLink ?? this.profileLink,
        evaluationEnabledForTeachers:
            evaluationEnabledForTeachers ?? this.evaluationEnabledForTeachers,
        evaluationEnabledForParents:
            evaluationEnabledForParents ?? this.evaluationEnabledForParents,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    slug: json["slug"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    emailAddress: json["emailAddress"],
    role: json["role"],
    lang: json["lang"],
    countryCode: json["countryCode"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    countryName: json["countryName"],
    stateName: json["stateName"],
    cityName: json["cityName"],
    zipCode: json["zipCode"],
    profileLink: json["profileLink"],
    evaluationEnabledForTeachers: json["evaluationEnabledForTeachers"],
    evaluationEnabledForParents: json["evaluationEnabledForParents"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "firstName": firstName,
    "lastName": lastName,
    "emailAddress": emailAddress,
    "role": role,
    "lang": lang,
    "countryCode": countryCode,
    "phoneNumber": phoneNumber,
    "address": address,
    "countryName": countryName,
    "stateName": stateName,
    "cityName": cityName,
    "zipCode": zipCode,
    "profileLink": profileLink,
    "evaluationEnabledForTeachers": evaluationEnabledForTeachers,
    "evaluationEnabledForParents": evaluationEnabledForParents,
  };
}
