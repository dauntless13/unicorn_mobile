// To parse this JSON data, do
//
//     final applyForTravelTripResponse = applyForTravelTripResponseFromJson(jsonString);

import 'dart:convert';

DeleteCommentResponse applyForTravelTripResponseFromJson(String str) => DeleteCommentResponse.fromJson(json.decode(str));

String applyForTravelTripResponseToJson(DeleteCommentResponse data) => json.encode(data.toJson());

class DeleteCommentResponse {
  bool? success;
  String? message;
  Data? data;

  DeleteCommentResponse({
    this.success,
    this.message,
    this.data,
  });

  DeleteCommentResponse copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      DeleteCommentResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory DeleteCommentResponse.fromJson(Map<String, dynamic> json) => DeleteCommentResponse(
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
  String? parentId;
  String? firstName;
  String? lastName;
  String? profileLink;
  String? comment;

  Data({
    this.parentId,
    this.firstName,
    this.lastName,
    this.profileLink,
    this.comment,
  });

  Data copyWith({
    String? parentId,
    String? firstName,
    String? lastName,
    String? profileLink,
    String? comment,
  }) =>
      Data(
        parentId: parentId ?? this.parentId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        profileLink: profileLink ?? this.profileLink,
        comment: comment ?? this.comment,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    parentId: json["parentId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileLink: json["profileLink"],
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "parentId": parentId,
    "firstName": firstName,
    "lastName": lastName,
    "profileLink": profileLink,
    "comment": comment,
  };
}
